import { Injectable, BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ProfilesService } from '../profiles/profiles.service';
import { GroupsService } from '../groups/groups.service';
import { CreateTopicDto } from './dto/create-topic.dto';
import { ReviewTopicDto } from './dto/review-topic.dto';
import { AddTopicMessageDto } from './dto/add-message.dto';

@Injectable()
export class ProjectTopicsService {
  constructor(
    private prisma: PrismaService,
    private profilesService: ProfilesService,
    private groupsService: GroupsService,
  ) {}

  async createTopic(userId: string, createTopicDto: CreateTopicDto) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile) {
      throw new BadRequestException('Profile not found');
    }

    if (profile.role !== 'student') {
      throw new ForbiddenException('Only students can submit topics');
    }

    const group = await this.groupsService.getMyGroup(userId);
    if (!group) {
      throw new BadRequestException('You must be in a group to submit a topic');
    }

    // Check if group already has an approved topic
    const existingTopic = await this.prisma.projectTopic.findFirst({
      where: {
        groupId: group.id,
        status: 'approved',
      },
    });

    if (existingTopic) {
      throw new BadRequestException('Your group already has an approved topic');
    }

    return this.prisma.projectTopic.create({
      data: {
        groupId: group.id,
        title: createTopicDto.title,
        description: createTopicDto.description,
        submittedBy: profile.id,
      },
    });
  }

  async getTopicsByGroup(userId: string) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile) {
      throw new BadRequestException('Profile not found');
    }

    const group = await this.groupsService.getMyGroup(userId);
    if (!group) {
      throw new BadRequestException('You must be in a group');
    }

    return this.prisma.projectTopic.findMany({
      where: { groupId: group.id },
      orderBy: { submittedAt: 'desc' },
    });
  }

  async approveTopic(userId: string, topicId: string) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile || (profile.role !== 'faculty' && profile.role !== 'super_admin')) {
      throw new ForbiddenException('Only faculty can approve topics');
    }

    const topic = await this.prisma.projectTopic.findUnique({
      where: { id: topicId },
    });

    if (!topic) {
      throw new NotFoundException('Topic not found');
    }

    if (topic.status === 'approved') {
      throw new BadRequestException('Topic is already approved');
    }

    return this.prisma.projectTopic.update({
      where: { id: topicId },
      data: {
        status: 'approved',
        reviewedBy: profile.id,
        reviewedAt: new Date(),
      },
    });
  }

  async rejectTopic(userId: string, topicId: string) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile || (profile.role !== 'faculty' && profile.role !== 'super_admin')) {
      throw new ForbiddenException('Only faculty can reject topics');
    }

    const topic = await this.prisma.projectTopic.findUnique({
      where: { id: topicId },
    });

    if (!topic) {
      throw new NotFoundException('Topic not found');
    }

    return this.prisma.projectTopic.update({
      where: { id: topicId },
      data: {
        status: 'rejected',
        reviewedBy: profile.id,
        reviewedAt: new Date(),
      },
    });
  }

  async requestRevision(userId: string, topicId: string, reviewTopicDto: ReviewTopicDto) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile || (profile.role !== 'faculty' && profile.role !== 'super_admin')) {
      throw new ForbiddenException('Only faculty can request revisions');
    }

    const topic = await this.prisma.projectTopic.findUnique({
      where: { id: topicId },
    });

    if (!topic) {
      throw new NotFoundException('Topic not found');
    }

    const updatedTopic = await this.prisma.projectTopic.update({
      where: { id: topicId },
      data: {
        status: 'revision_requested',
        reviewedBy: profile.id,
        reviewedAt: new Date(),
      },
    });

    // Add feedback as a message if provided
    if (reviewTopicDto.feedback) {
      await this.addMessage(userId, {
        topicId,
        content: reviewTopicDto.feedback,
      });
    }

    return updatedTopic;
  }

  async addMessage(userId: string, addMessageDto: AddTopicMessageDto) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile) {
      throw new BadRequestException('Profile not found');
    }

    return this.prisma.topicMessage.create({
      data: {
        topicId: addMessageDto.topicId,
        groupId: '', // Will be filled from topic if needed
        authorId: profile.id,
        authorName: profile.name,
        authorRole: profile.role === 'student' ? 'student' : 'faculty',
        content: addMessageDto.content,
        links: addMessageDto.links || [],
      },
    });
  }

  async getMessagesByTopic(topicId: string) {
    return this.prisma.topicMessage.findMany({
      where: { topicId },
      orderBy: { createdAt: 'asc' },
    });
  }

  async getMessagesByGroup(userId: string) {
    const group = await this.groupsService.getMyGroup(userId);
    if (!group) {
      throw new BadRequestException('You must be in a group');
    }

    return this.prisma.topicMessage.findMany({
      where: { groupId: group.id },
      orderBy: { createdAt: 'asc' },
    });
  }
}

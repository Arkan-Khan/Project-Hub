import { Injectable, BadRequestException, ForbiddenException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ProfilesService } from '../profiles/profiles.service';
import { GroupsService } from '../groups/groups.service';

@Injectable()
export class MentorAllocationsService {
  constructor(
    private prisma: PrismaService,
    private profilesService: ProfilesService,
    private groupsService: GroupsService,
  ) {}

  async getAllocationsForMentor(userId: string) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile) {
      throw new BadRequestException('Profile not found');
    }

    if (profile.role !== 'faculty' && profile.role !== 'super_admin') {
      throw new ForbiddenException('Only faculty can view allocations');
    }

    const allocations = await this.prisma.mentorAllocation.findMany({
      where: { mentorId: profile.id },
      include: {
        group: {
          include: {
            members: {
              include: {
                profile: true,
              },
            },
            creator: true,
          },
        },
        form: true,
      },
      orderBy: [
        { status: 'asc' }, // pending first
        { preferenceRank: 'asc' },
      ],
    });

    return allocations;
  }

  async getAllocationsForGroup(userId: string) {
    const group = await this.groupsService.getMyGroup(userId);
    if (!group) {
      return [];
    }

    return this.prisma.mentorAllocation.findMany({
      where: { groupId: group.id },
      include: {
        mentor: true,
        form: true,
      },
      orderBy: { preferenceRank: 'asc' },
    });
  }

  async acceptAllocation(userId: string, allocationId: string) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile) {
      throw new BadRequestException('Profile not found');
    }

    if (profile.role !== 'faculty' && profile.role !== 'super_admin') {
      throw new ForbiddenException('Only faculty can accept allocations');
    }

    const allocation = await this.prisma.mentorAllocation.findUnique({
      where: { id: allocationId },
    });

    if (!allocation) {
      throw new NotFoundException('Allocation not found');
    }

    if (allocation.mentorId !== profile.id) {
      throw new ForbiddenException('Can only accept your own allocations');
    }

    if (allocation.status !== 'pending') {
      throw new BadRequestException('Allocation is not pending');
    }

    // Update in a transaction - accept this one, reject all others for the same group
    await this.prisma.$transaction(async (tx) => {
      // Accept this allocation
      await tx.mentorAllocation.update({
        where: { id: allocationId },
        data: { status: 'accepted' },
      });

      // Reject all other allocations for the same group
      await tx.mentorAllocation.updateMany({
        where: {
          groupId: allocation.groupId,
          id: { not: allocationId },
        },
        data: { status: 'rejected' },
      });
    });

    return { message: 'Team accepted successfully' };
  }

  async rejectAllocation(userId: string, allocationId: string) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile) {
      throw new BadRequestException('Profile not found');
    }

    if (profile.role !== 'faculty' && profile.role !== 'super_admin') {
      throw new ForbiddenException('Only faculty can reject allocations');
    }

    const allocation = await this.prisma.mentorAllocation.findUnique({
      where: { id: allocationId },
    });

    if (!allocation) {
      throw new NotFoundException('Allocation not found');
    }

    if (allocation.mentorId !== profile.id) {
      throw new ForbiddenException('Can only reject your own allocations');
    }

    if (allocation.status !== 'pending') {
      throw new BadRequestException('Allocation is not pending');
    }

    await this.prisma.mentorAllocation.update({
      where: { id: allocationId },
      data: { status: 'rejected' },
    });

    return { message: 'Team rejected' };
  }

  async getAcceptedMentor(userId: string) {
    const group = await this.groupsService.getMyGroup(userId);
    if (!group) {
      return null;
    }

    const acceptedAllocation = await this.prisma.mentorAllocation.findFirst({
      where: {
        groupId: group.id,
        status: 'accepted',
      },
      include: {
        mentor: true,
      },
    });

    if (!acceptedAllocation) {
      return null;
    }

    return {
      mentor: acceptedAllocation.mentor,
      status: 'accepted',
    };
  }

  async getMentorStatus(userId: string) {
    const group = await this.groupsService.getMyGroup(userId);
    if (!group) {
      return { status: 'no_group' };
    }

    const allocations = await this.prisma.mentorAllocation.findMany({
      where: { groupId: group.id },
      include: { mentor: true },
      orderBy: { preferenceRank: 'asc' },
    });

    if (allocations.length === 0) {
      return { status: 'not_submitted' };
    }

    const acceptedAllocation = allocations.find(a => a.status === 'accepted');
    if (acceptedAllocation) {
      return {
        status: 'accepted',
        mentorName: acceptedAllocation.mentor.name,
        mentorId: acceptedAllocation.mentorId,
      };
    }

    const pendingAllocations = allocations.filter(a => a.status === 'pending');
    if (pendingAllocations.length > 0) {
      return { status: 'pending' };
    }

    return { status: 'all_rejected' };
  }

  async getAcceptedTeams(userId: string) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile) {
      throw new BadRequestException('Profile not found');
    }

    if (profile.role !== 'faculty' && profile.role !== 'super_admin') {
      throw new ForbiddenException('Only faculty can view accepted teams');
    }

    return this.prisma.mentorAllocation.findMany({
      where: {
        mentorId: profile.id,
        status: 'accepted',
      },
      include: {
        group: {
          include: {
            members: {
              include: {
                profile: true,
              },
            },
            creator: true,
          },
        },
      },
    });
  }
}

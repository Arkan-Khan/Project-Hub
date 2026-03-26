import {
  Injectable,
  BadRequestException,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ProfilesService } from '../profiles/profiles.service';
import { GroupsService } from '../groups/groups.service';
import { SupabaseService } from '../supabase/supabase.service';
import { AttachmentStage } from '@prisma/client';

const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB

const ALLOWED_MIME_TYPES = [
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.ms-powerpoint',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'application/vnd.ms-excel',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'image/png',
  'image/jpeg',
  'image/gif',
  'application/zip',
  'application/x-rar-compressed',
  'text/plain',
];

@Injectable()
export class AttachmentsService {
  constructor(
    private prisma: PrismaService,
    private profilesService: ProfilesService,
    private groupsService: GroupsService,
    private supabaseService: SupabaseService,
  ) {}

  private async verifyGroupLeader(userId: string) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile) {
      throw new BadRequestException('Profile not found');
    }

    if (profile.role !== 'student') {
      throw new ForbiddenException('Only students can manage attachments');
    }

    const group = await this.groupsService.findByMemberId(profile.id);
    if (!group) {
      throw new NotFoundException('You are not in a group');
    }

    if (group.createdBy !== profile.id) {
      throw new ForbiddenException('Only the group leader can upload attachments');
    }

    return { profile, group };
  }

  async uploadAttachment(
    userId: string,
    stage: AttachmentStage,
    file: Express.Multer.File,
  ) {
    const { profile, group } = await this.verifyGroupLeader(userId);

    // Validate file size
    if (file.size > MAX_FILE_SIZE) {
      throw new BadRequestException(
        `File size exceeds maximum allowed size of ${MAX_FILE_SIZE / (1024 * 1024)} MB`,
      );
    }

    // Validate file type
    if (!ALLOWED_MIME_TYPES.includes(file.mimetype)) {
      throw new BadRequestException(
        `File type ${file.mimetype} is not allowed. Allowed types: PDF, Word, PowerPoint, Excel, images, ZIP, RAR, TXT`,
      );
    }

    // Check if there's already an attachment for this stage
    const existing = await this.prisma.attachment.findUnique({
      where: {
        groupId_stage: {
          groupId: group.id,
          stage,
        },
      },
    });

    // Generate storage path
    const fileExtension = file.originalname.split('.').pop() || '';
    const storagePath = `${group.id}/${stage}/${Date.now()}.${fileExtension}`;

    // Upload to Supabase
    const fileUrl = await this.supabaseService.uploadFile(
      storagePath,
      file.buffer,
      file.mimetype,
    );

    // If there was an existing attachment, delete the old file
    if (existing) {
      // Extract old path from URL (last 3 segments)
      const oldPath = existing.fileUrl.split('/').slice(-3).join('/');
      try {
        await this.supabaseService.deleteFile(oldPath);
      } catch (error) {
        console.error('Failed to delete old file:', error);
      }

      // Update existing record
      return this.prisma.attachment.update({
        where: { id: existing.id },
        data: {
          filename: file.originalname,
          fileUrl,
          fileSize: file.size,
          mimeType: file.mimetype,
          uploadedBy: profile.id,
          uploadedAt: new Date(),
        },
      });
    }

    // Create new attachment record
    return this.prisma.attachment.create({
      data: {
        groupId: group.id,
        stage,
        filename: file.originalname,
        fileUrl,
        fileSize: file.size,
        mimeType: file.mimetype,
        uploadedBy: profile.id,
      },
    });
  }

  async getAttachmentsByGroup(groupId: string) {
    return this.prisma.attachment.findMany({
      where: { groupId },
      orderBy: { stage: 'asc' },
    });
  }

  async getMyGroupAttachments(userId: string) {
    const profile = await this.profilesService.findByUserId(userId);
    if (!profile) {
      return [];
    }

    const group = await this.groupsService.findByMemberId(profile.id);
    if (!group) {
      return [];
    }

    return this.getAttachmentsByGroup(group.id);
  }

  async deleteAttachment(userId: string, attachmentId: string) {
    const { group } = await this.verifyGroupLeader(userId);

    const attachment = await this.prisma.attachment.findUnique({
      where: { id: attachmentId },
    });

    if (!attachment) {
      throw new NotFoundException('Attachment not found');
    }

    if (attachment.groupId !== group.id) {
      throw new ForbiddenException('Cannot delete attachments from other groups');
    }

    // Delete from Supabase
    const storagePath = attachment.fileUrl.split('/').slice(-3).join('/');
    try {
      await this.supabaseService.deleteFile(storagePath);
    } catch (error) {
      console.error('Failed to delete file from storage:', error);
    }

    // Delete from database
    await this.prisma.attachment.delete({
      where: { id: attachmentId },
    });

    return { message: 'Attachment deleted successfully' };
  }
}

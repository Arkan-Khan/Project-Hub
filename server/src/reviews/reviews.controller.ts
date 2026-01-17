import { Controller, Post, Body, Get, Param, Patch, UseGuards, Request } from '@nestjs/common';
import { Request as ExpressRequest } from 'express';
import { ReviewsService } from './reviews.service';
import { RolloutReviewDto } from './dto/rollout-review.dto';
import { SubmitProgressDto } from './dto/submit-progress.dto';
import { SubmitFeedbackDto } from './dto/submit-feedback.dto';
import { AddReviewMessageDto } from './dto/add-message.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ReviewType } from '@prisma/client';

@Controller('reviews')
export class ReviewsController {
  constructor(private reviewsService: ReviewsService) {}

  @UseGuards(JwtAuthGuard)
  @Post('rollout')
  async rollout(@Request() req: ExpressRequest, @Body() rolloutDto: RolloutReviewDto) {
    return this.reviewsService.rolloutReview(req.user.userId, rolloutDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get('rollout/:reviewType')
  async getRollout(@Request() req: ExpressRequest, @Param('reviewType') reviewType: ReviewType) {
    return this.reviewsService.getReviewRollout(req.user.userId, reviewType);
  }

  @UseGuards(JwtAuthGuard)
  @Post('submit/:reviewType')
  async submitProgress(
    @Request() req: ExpressRequest,
    @Param('reviewType') reviewType: ReviewType,
    @Body() submitDto: SubmitProgressDto,
  ) {
    return this.reviewsService.submitProgress(req.user.userId, reviewType, submitDto);
  }

  @UseGuards(JwtAuthGuard)
  @Post('feedback/:sessionId')
  async submitFeedback(
    @Request() req: ExpressRequest,
    @Param('sessionId') sessionId: string,
    @Body() feedbackDto: SubmitFeedbackDto,
  ) {
    return this.reviewsService.submitFeedback(req.user.userId, sessionId, feedbackDto);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':sessionId/complete')
  async markComplete(@Request() req: ExpressRequest, @Param('sessionId') sessionId: string) {
    return this.reviewsService.markComplete(req.user.userId, sessionId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('session/:reviewType')
  async getMySession(@Request() req: ExpressRequest, @Param('reviewType') reviewType: ReviewType) {
    return this.reviewsService.getMyReviewSession(req.user.userId, reviewType);
  }

  @UseGuards(JwtAuthGuard)
  @Post('messages')
  async addMessage(@Request() req: ExpressRequest, @Body() addMessageDto: AddReviewMessageDto) {
    return this.reviewsService.addMessage(req.user.userId, addMessageDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get('messages/session/:sessionId')
  async getMessagesBySession(@Param('sessionId') sessionId: string) {
    return this.reviewsService.getMessagesBySession(sessionId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('messages/:reviewType')
  async getMyMessages(@Request() req: ExpressRequest, @Param('reviewType') reviewType: ReviewType) {
    return this.reviewsService.getMyReviewMessages(req.user.userId, reviewType);
  }
}

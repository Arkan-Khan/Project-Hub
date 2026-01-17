import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { ProfilesModule } from './profiles/profiles.module';
import { GroupsModule } from './groups/groups.module';
import { MentorFormsModule } from './mentor-forms/mentor-forms.module';
import { MentorPreferencesModule } from './mentor-preferences/mentor-preferences.module';
import { MentorAllocationsModule } from './mentor-allocations/mentor-allocations.module';
import { ProjectTopicsModule } from './project-topics/project-topics.module';
import { ReviewsModule } from './reviews/reviews.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    PrismaModule,
    AuthModule,
    UsersModule,
    ProfilesModule,
    GroupsModule,
    MentorFormsModule,
    MentorPreferencesModule,
    MentorAllocationsModule,
    ProjectTopicsModule,
    ReviewsModule,
  ],
})
export class AppModule {}

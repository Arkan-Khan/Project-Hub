# Backend Guide

## Tech Stack
- **Framework**: NestJS
- **Language**: TypeScript
- **ORM**: Prisma
- **Database**: PostgreSQL (Supabase)
- **Auth**: JWT (Supabase Auth integration)
- **File Storage**: Supabase Storage

## Directory Structure

```
server/
├── src/
│   ├── main.ts                    # Application entry point
│   ├── app.module.ts              # Root module
│   ├── auth/
│   │   ├── auth.module.ts
│   │   ├── auth.controller.ts     # Login, register, profile
│   │   ├── auth.service.ts
│   │   └── jwt.guard.ts           # JWT authentication guard
│   ├── groups/
│   │   ├── groups.module.ts
│   │   ├── groups.controller.ts   # Group CRUD operations
│   │   └── groups.service.ts
│   ├── topics/
│   │   ├── topics.module.ts
│   │   ├── topics.controller.ts   # Topic submission and approval
│   │   └── topics.service.ts
│   ├── allocations/
│   │   ├── allocations.module.ts
│   │   ├── allocations.controller.ts  # Mentor preferences and allocation
│   │   └── allocations.service.ts
│   ├── reviews/
│   │   ├── reviews.module.ts
│   │   ├── reviews.controller.ts  # Review rollout, progress, feedback
│   │   └── reviews.service.ts
│   ├── attachments/
│   │   ├── attachments.module.ts
│   │   ├── attachments.controller.ts  # File upload/download
│   │   └── attachments.service.ts
│   ├── admin/
│   │   ├── admin.module.ts
│   │   ├── admin.controller.ts    # Admin-only operations
│   │   └── admin.service.ts
│   └── prisma/
│       ├── prisma.module.ts
│       └── prisma.service.ts      # Prisma client singleton
├── prisma/
│   ├── schema.prisma              # Database schema (312 lines)
│   └── migrations/                # Database migrations
└── package.json
```

## Prisma Schema (`prisma/schema.prisma`)

### Profile Model
```prisma
model Profile {
  id          String   @id @default(uuid())
  userId      String   @unique  // Supabase Auth user ID
  name        String
  email       String   @unique
  role        Role     @default(student)
  department  String?
  rollNumber  String?            // Students only
  semester    Int?               // Students only (1-8)
  domains     String?            // Faculty only (comma-separated)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

enum Role {
  student
  faculty
  superadmin
}
```

### Group Model
```prisma
model Group {
  id          String   @id @default(uuid())
  groupId     String   @unique  // e.g., "IT03"
  teamCode    String   @unique  // e.g., "A7DXQ"
  department  String
  createdBy   String            // Profile ID of creator
  isFull      Boolean  @default(false)
  meetLink    String?           // Google Meet link
  createdAt   DateTime @default(now())
  
  creator     Profile  @relation("GroupCreator", fields: [createdBy], references: [id])
  members     GroupMember[]
  topics      Topic[]
  preferences MentorPreference[]
  allocations MentorAllocation[]
  reviews     ReviewSession[]
  attachments Attachment[]
}

model GroupMember {
  id        String   @id @default(uuid())
  groupId   String
  profileId String
  joinedAt  DateTime @default(now())
  
  group     Group    @relation(fields: [groupId], references: [id])
  profile   Profile  @relation(fields: [profileId], references: [id])
  
  @@unique([groupId, profileId])
}
```

### Topic Model
```prisma
model Topic {
  id          String      @id @default(uuid())
  groupId     String
  title       String
  description String
  status      TopicStatus @default(pending)
  feedback    String?               // Mentor feedback
  submittedBy String
  submittedAt DateTime    @default(now())
  reviewedBy  String?
  reviewedAt  DateTime?
  
  group       Group       @relation(fields: [groupId], references: [id])
}

enum TopicStatus {
  pending
  approved
  rejected
  revision
}
```

### Mentor Allocation Models
```prisma
model MentorPreference {
  id        String   @id @default(uuid())
  groupId   String
  mentorId  String            // Profile ID of faculty
  rank      Int               // 1, 2, or 3
  createdAt DateTime @default(now())
  
  group     Group    @relation(fields: [groupId], references: [id])
  mentor    Profile  @relation(fields: [mentorId], references: [id])
  
  @@unique([groupId, mentorId])
  @@unique([groupId, rank])
}

model MentorAllocation {
  id        String           @id @default(uuid())
  groupId   String
  mentorId  String
  status    AllocationStatus @default(pending)
  rank      Int?                       // Which preference (1, 2, 3)
  isManual  Boolean          @default(false)  // Manually allocated by admin
  createdAt DateTime         @default(now())
  updatedAt DateTime         @updatedAt
  
  group     Group    @relation(fields: [groupId], references: [id])
  mentor    Profile  @relation(fields: [mentorId], references: [id])
  
  @@unique([groupId, mentorId])
}

enum AllocationStatus {
  pending
  accepted
  rejected
}
```

### Review Models
```prisma
model ReviewSession {
  id                  String       @id @default(uuid())
  groupId             String
  reviewType          ReviewType
  status              ReviewStatus @default(not_started)
  progressPercentage  Int?         // 0-100
  progressDescription String?
  submittedBy         String?
  submittedAt         DateTime?
  mentorFeedback      String?
  feedbackGivenBy     String?
  feedbackGivenAt     DateTime?
  meetLink            String?               // Google Meet link for this review
  createdAt           DateTime     @default(now())
  updatedAt           DateTime     @updatedAt
  
  group     Group           @relation(fields: [groupId], references: [id])
  messages  ReviewMessage[]
  
  @@unique([groupId, reviewType])
}

model ReviewMessage {
  id        String   @id @default(uuid())
  sessionId String
  senderId  String
  content   String
  createdAt DateTime @default(now())
  
  session   ReviewSession @relation(fields: [sessionId], references: [id])
  sender    Profile       @relation(fields: [senderId], references: [id])
}

enum ReviewType {
  review_1
  review_2
  final_review
}

enum ReviewStatus {
  not_started
  in_progress
  submitted
  feedback_given
  completed
}
```

### Attachment Model
```prisma
model Attachment {
  id         String   @id @default(uuid())
  groupId    String
  stage      String             // topic_approval, review_1, review_2, final_review
  filename   String
  fileUrl    String
  fileSize   Int
  mimeType   String
  uploadedBy String
  uploadedAt DateTime @default(now())
  
  group      Group    @relation(fields: [groupId], references: [id])
  uploader   Profile  @relation(fields: [uploadedBy], references: [id])
  
  @@unique([groupId, stage])   // One attachment per stage per group
}
```

### Settings Model (Global Config)
```prisma
model Settings {
  id                    String   @id @default(uuid())
  mentorFormActive      Boolean  @default(false)
  review1Active         Boolean  @default(false)
  review2Active         Boolean  @default(false)
  finalReviewActive     Boolean  @default(false)
  updatedAt             DateTime @updatedAt
}
```

## Key Controllers

### Groups Controller (`src/groups/groups.controller.ts`)
```typescript
@Controller('groups')
export class GroupsController {
  @Post('create')           // Create new group, returns team code
  @Post('join')             // Join group by team code
  @Get('my-group')          // Get current user's group
  @Get('by-id/:id')         // Get group by ID
  @Get('by-team-code/:code')
  @Get('by-department/:dept')
  @Get('with-details/:dept') // Groups with member details and mentor info
  @Patch('meet-link')       // Set Google Meet link
}
```

### Reviews Controller (`src/reviews/reviews.controller.ts`)
```typescript
@Controller('reviews')
export class ReviewsController {
  @Post('rollout')                    // Activate review phase (admin)
  @Get('rollout/:reviewType')         // Check if review is active
  @Post('submit/:reviewType')         // Submit progress
  @Post('feedback/:sessionId')        // Submit mentor feedback
  @Patch(':sessionId/complete')       // Mark review complete
  @Patch(':sessionId/meet-link')      // Set meet link
  @Get('session/:reviewType')         // Get user's review session
  @Get('session/:reviewType/group/:groupId')  // Get group's session
  @Post('messages')                   // Add message
  @Get('messages/session/:sessionId') // Get session messages
  @Get('messages/:reviewType')        // Get user's messages
}
```

### Admin Controller (`src/admin/admin.controller.ts`)
```typescript
@Controller('admin')
export class AdminController {
  @Get('mentor-overview')      // All mentors with their groups and review status
  @Get('unassigned-groups')    // Groups without accepted mentor
  @Get('available-mentors')    // Faculty available for allocation
  @Post('allocate-mentor')     // Manually assign mentor to group
}
```

### Attachments Controller (`src/attachments/attachments.controller.ts`)
```typescript
@Controller('attachments')
export class AttachmentsController {
  @Post('upload/:stage')       // Upload file with FileInterceptor
  @Get('my-group')             // Get group's attachments
  @Get('group/:groupId')       // Get specific group's attachments
  @Delete(':id')               // Delete attachment
}
```

## Authentication

### JWT Guard (`src/auth/jwt.guard.ts`)
- Validates JWT token from Authorization header
- Extracts user ID from token
- Attaches user profile to request object

### Usage
```typescript
@UseGuards(JwtAuthGuard)
@Get('protected-route')
async protectedRoute(@Req() req) {
  const user = req.user  // Profile object
}
```

## Common Patterns

### Controller Method Structure
```typescript
@Post('endpoint')
@UseGuards(JwtAuthGuard)
async methodName(
  @Req() req,
  @Body() body: CreateDto,
  @Param('id') id: string
) {
  const userId = req.user.id
  return this.service.method(userId, body)
}
```

### Service Method Structure
```typescript
async methodName(userId: string, data: CreateDto) {
  // Validate user permissions
  const profile = await this.prisma.profile.findUnique({ where: { id: userId } })
  
  // Perform operation
  const result = await this.prisma.model.create({
    data: { ...data },
    include: { relation: true }
  })
  
  return result
}
```

### Error Handling
```typescript
import { BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common'

throw new BadRequestException('Invalid input')
throw new NotFoundException('Resource not found')
throw new ForbiddenException('Access denied')
```

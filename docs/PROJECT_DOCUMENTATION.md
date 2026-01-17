# ProjectHub - Complete Documentation

> A comprehensive full-stack platform for managing college projects with mentor allocation, topic approval, and review workflows.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Architecture](#3-architecture)
4. [Database Schema](#4-database-schema)
5. [Authentication](#5-authentication)
6. [User Roles & Workflows](#6-user-roles--workflows)
7. [API Reference](#7-api-reference)
8. [Frontend Pages](#8-frontend-pages)
9. [Setup Guide](#9-setup-guide)
10. [Test Accounts](#10-test-accounts)
11. [Troubleshooting](#11-troubleshooting)

---

## 1. Project Overview

### What is ProjectHub?

ProjectHub is a college project management system designed to streamline:

- **Group Formation**: Students create/join teams (max 3 members)
- **Mentor Allocation**: Students submit preferences, faculty accept/reject
- **Topic Approval**: Students submit project topics, mentors approve via chat
- **Review Workflow**: Structured review phases (R1 → R2 → Final) with progress tracking

### Key Features

| Feature | Description |
|---------|-------------|
| **Role-Based Access** | Different dashboards for Student, Faculty, Super Admin |
| **Department Isolation** | All data scoped to department (IT, CS, ECS, ETC, BM) |
| **Chat Interface** | Real-time discussion threads for topic and review discussions |
| **Review Chaining** | R2 unlocks after R1 complete, Final unlocks after R2 complete |
| **JWT Authentication** | Secure 7-day tokens with automatic refresh |

---

## 2. Tech Stack

### Backend
| Technology | Purpose |
|------------|---------|
| **NestJS** | Server framework with TypeScript |
| **Prisma** | ORM for database operations |
| **PostgreSQL** | Database (via Supabase) |
| **JWT** | Authentication tokens |
| **bcrypt** | Password hashing |
| **class-validator** | Request validation |

### Frontend
| Technology | Purpose |
|------------|---------|
| **Next.js 15** | React framework with App Router |
| **TypeScript** | Type safety |
| **TailwindCSS** | Styling |
| **Shadcn/UI** | Component library |
| **Lucide React** | Icons |

### Design System
- **Primary Color**: Indigo `#4F46E5`
- **Accent Color**: Amber `#FBBF24`
- **Background**: White `#FFFFFF`
- **Style**: Clean, minimal, academic interface

---

## 3. Architecture

### Project Structure

```
Project-Hub/
├── client/                     # Next.js Frontend
│   ├── app/                    # Pages (App Router)
│   │   ├── auth/               # Login & Signup
│   │   ├── dashboard/          # Role-based dashboards
│   │   └── onboarding/         # Profile creation
│   ├── components/             # Reusable UI components
│   ├── lib/                    # API client, auth context
│   └── types/                  # TypeScript interfaces
│
├── server/                     # NestJS Backend
│   ├── prisma/                 # Database schema & migrations
│   └── src/
│       ├── auth/               # Authentication module
│       ├── profiles/           # User profiles
│       ├── groups/             # Team management
│       ├── mentor-forms/       # Form rollout
│       ├── mentor-preferences/ # Student choices
│       ├── mentor-allocations/ # Faculty responses
│       ├── project-topics/     # Topic approval system
│       └── reviews/            # Review workflow
│
└── docs/                       # Documentation
```

### Data Flow

```
User Request → API Client (with JWT) → NestJS Controller → Service → Prisma → PostgreSQL
                                                                          ↓
User UI ← React Component ← API Response ← Controller ← Service ← Database Result
```

---

## 4. Database Schema

### Core Models

#### User & Profile
```prisma
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  password  String   // bcrypt hashed
  profile   Profile?
}

model Profile {
  id         String     @id
  userId     String     @unique
  name       String
  email      String
  role       Role       // student | faculty | super_admin
  department Department // IT | CS | ECS | ETC | BM
  rollNumber String?    // Students only
  semester   Int?       // Students only
}
```

#### Groups & Members
```prisma
model Group {
  id         String     @id
  groupId    String     @unique  // e.g., "IT01", "CS03"
  teamCode   String     @unique  // e.g., "A7DXQ"
  department Department
  createdBy  String     // Profile ID of leader
  isFull     Boolean    // true when 3 members
  members    GroupMember[]
}

model GroupMember {
  groupId   String
  profileId String
  @@unique([groupId, profileId])
}
```

#### Mentor Allocation
```prisma
model MentorAllocationForm {
  id         String     @id
  department Department
  isActive   Boolean
  createdBy  String     // Super Admin profile ID
  availableMentors AvailableMentor[]
}

model MentorPreference {
  id            String @id
  groupId       String
  formId        String
  mentorChoice1 String // 1st preference mentor ID
  mentorChoice2 String // 2nd preference mentor ID
  mentorChoice3 String // 3rd preference mentor ID
  submittedBy   String // Leader profile ID
  @@unique([groupId, formId])
}

model MentorAllocation {
  id             String           @id
  groupId        String
  mentorId       String
  formId         String
  status         AllocationStatus // pending | accepted | rejected
  preferenceRank Int              // 1, 2, or 3
  @@unique([groupId, mentorId, formId])
}
```

#### Topic Approval
```prisma
model ProjectTopic {
  id          String      @id
  groupId     String
  title       String
  description String
  status      TopicStatus // submitted | under_review | approved | rejected | revision_requested
  submittedBy String
  reviewedBy  String?
  messages    TopicMessage[]
}

model TopicMessage {
  id         String   @id
  topicId    String?  // null for general discussion
  groupId    String
  authorId   String
  authorName String
  authorRole String   // "student" or "faculty"
  content    String
  links      String[]
}
```

#### Review System
```prisma
model ReviewRollout {
  id         String     @id
  department Department
  reviewType ReviewType // review_1 | review_2 | final_review
  isActive   Boolean
  createdBy  String     // Super Admin profile ID
  @@unique([department, reviewType])
}

model ReviewSession {
  id                  String       @id
  groupId             String
  reviewType          ReviewType
  status              ReviewStatus // not_started | in_progress | submitted | feedback_given | completed
  progressPercentage  Int          // 0-100
  progressDescription String
  submittedBy         String
  mentorFeedback      String?
  messages            ReviewMessage[]
  @@unique([groupId, reviewType])
}

model ReviewMessage {
  id         String @id
  sessionId  String
  groupId    String
  authorId   String
  authorName String
  authorRole String
  content    String
  links      String[]
}
```

### Enums
```prisma
enum Role { student, faculty, super_admin }
enum Department { IT, CS, ECS, ETC, BM }
enum AllocationStatus { pending, accepted, rejected }
enum TopicStatus { submitted, under_review, approved, rejected, revision_requested }
enum ReviewType { review_1, review_2, final_review }
enum ReviewStatus { not_started, in_progress, submitted, feedback_given, completed }
```

---

## 5. Authentication

### JWT Flow

1. **Signup**: Create User → Hash password → Generate JWT
2. **Login**: Verify password → Generate JWT (7-day expiry)
3. **Protected Routes**: JWT in `Authorization: Bearer <token>` header
4. **Token Validation**: Verify signature → Extract userId → Load user

### Frontend Auth

```typescript
// lib/auth-context.tsx manages:
- Token storage in localStorage
- Auto-injection in API requests
- Redirect on 401 responses
- Loading state during auth check

// Protected pages check:
if (authLoading) return <Loading />
if (!user) redirect('/auth/login')
```

### Access Codes (Super Admin)

| Department | Code |
|------------|------|
| IT | `ITADMIN2025` |
| CS | `CSADMIN2025` |
| ECS | `ECSADMIN2025` |
| ETC | `ETCADMIN2025` |
| BM | `BMADMIN2025` |

---

## 6. User Roles & Workflows

### Student Workflow

```
1. Sign Up → Onboarding (profile creation)
2. Create Group OR Join Group (with team code)
3. Wait for Super Admin to roll out mentor allocation form
4. Submit mentor preferences (leader only, 3 choices)
5. Wait for faculty to accept
6. After mentor assigned → Submit project topics (up to 3)
7. Discuss topics with mentor in chat
8. After topic approved → Wait for review rollout
9. Review 1 → Submit progress + discuss → Complete
10. Review 2 → Submit progress + discuss → Complete
11. Final Review → Complete project
```

### Faculty Workflow

```
1. Sign Up → Onboarding (select Faculty role)
2. Wait to be added to mentor allocation form
3. View pending team requests (see preference rank)
4. Accept OR Reject teams
5. For accepted teams:
   - View submitted topics
   - Discuss in chat thread
   - Approve one topic OR request revision
6. During review phases:
   - View student progress submissions
   - Provide feedback in chat
   - Mark reviews as complete
```

### Super Admin Workflow

```
1. Sign Up → Onboarding (use access code)
2. Roll out mentor allocation form:
   - Select available faculty
   - Can include self as mentor
3. Monitor department groups
4. Roll out review phases:
   - Review 1, Review 2, Final Review
   - Each activates for entire department
5. Can also act as mentor (same as faculty)
```

### Review Chaining Logic

```
Topic Approved?
├─ YES → Review 1 unlocked (if rolled out)
│        │
│        Review 1 Completed?
│        ├─ YES → Review 2 unlocked (if rolled out)
│        │        │
│        │        Review 2 Completed?
│        │        ├─ YES → Final Review unlocked (if rolled out)
│        │        └─ NO → Final Review locked
│        └─ NO → Review 2 locked
└─ NO → All reviews locked
```

---

## 7. API Reference

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Create new user |
| POST | `/api/auth/login` | Login and get token |
| GET | `/api/auth/me` | Get current user |

### Profile Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/profiles` | Create profile |
| GET | `/api/profiles/me` | Get my profile |
| GET | `/api/profiles/faculty/:department` | List faculty in department |

### Group Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/groups/create` | Create new group |
| POST | `/api/groups/join` | Join existing group |
| GET | `/api/groups/my-group` | Get my group |
| GET | `/api/groups/with-details/:department` | Get all groups with member details |

### Mentor Form Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/mentor-forms` | Create/rollout form |
| GET | `/api/mentor-forms/active` | Get active form |

### Mentor Preference Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/mentor-preferences` | Submit preferences |
| GET | `/api/mentor-preferences/my-preferences` | Get my preferences |

### Mentor Allocation Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/mentor-allocations/for-mentor` | Get requests for mentor |
| GET | `/api/mentor-allocations/for-mentor/accepted` | Get accepted allocations |
| POST | `/api/mentor-allocations/:id/accept` | Accept team request |
| POST | `/api/mentor-allocations/:id/reject` | Reject team request |

### Topic Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/project-topics` | Submit new topic |
| GET | `/api/project-topics/group/:groupId` | Get topics for group |
| GET | `/api/project-topics/messages/group/:groupId` | Get messages for group |
| POST | `/api/project-topics/messages` | Send message |
| POST | `/api/project-topics/:id/status` | Update topic status |

### Review Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/reviews/rollout` | Roll out review phase |
| GET | `/api/reviews/rollouts/:department` | Get rollouts for department |
| POST | `/api/reviews/session` | Create/submit review |
| GET | `/api/reviews/session/:reviewType/group/:groupId` | Get session by group |
| POST | `/api/reviews/session/:id/status` | Update session status |
| POST | `/api/reviews/messages` | Send review message |

---

## 8. Frontend Pages

### Public Pages

| Route | Description |
|-------|-------------|
| `/` | Landing page |
| `/auth/login` | Login form |
| `/auth/signup` | Signup form |

### Protected Pages

| Route | Role | Description |
|-------|------|-------------|
| `/onboarding` | All | Profile creation |
| `/dashboard` | All | Role-based redirect |
| `/dashboard/student` | Student | Student dashboard |
| `/dashboard/student/project-progress` | Student | Topic & review interface |
| `/dashboard/faculty` | Faculty | Mentor dashboard |
| `/dashboard/admin` | Super Admin | Admin dashboard |

### Components

| Component | Purpose |
|-----------|---------|
| `DashboardLayout` | Common layout with header |
| `ThreadPanel` | Reusable chat interface |
| `TopicApprovalSection` | Topic submission & approval |
| `ReviewSection` | Review progress & feedback |

---

## 9. Setup Guide

### Prerequisites

- Node.js v18+
- Supabase account (free tier works)
- npm or yarn

### Backend Setup

```bash
# 1. Navigate to server
cd server

# 2. Install dependencies
npm install

# 3. Create .env file
cat > .env << EOF
DATABASE_URL="postgresql://postgres:[password]@[host]:5432/postgres"
DIRECT_URL="postgresql://postgres:[password]@[host]:5432/postgres"
JWT_SECRET="your-secret-key-min-32-chars"
EOF

# 4. Initialize database
npx prisma generate
npx prisma db push

# 5. (Optional) Seed demo data
psql $DATABASE_URL -f seed-demo-data.sql

# 6. Start server
npm run start:dev
# Server runs on http://localhost:3001
```

### Frontend Setup

```bash
# 1. Navigate to client
cd client

# 2. Install dependencies
npm install

# 3. Create .env.local file
echo "NEXT_PUBLIC_API_URL=http://localhost:3001/api" > .env.local

# 4. Start development server
npm run dev
# App runs on http://localhost:3000
```

### Database Commands

```bash
# View database GUI
npm run db:studio  # Opens http://localhost:5555

# Reset database
npx prisma db push --force-reset

# Generate Prisma client
npx prisma generate
```

---

## 10. Test Accounts

### Seed Data Overview

The seed script creates:
- **4 Teams** (IT01, IT02, IT03, IT04) with 3 students each
- **3 Faculty** mentors
- **1 Super Admin**
- All teams have **ACCEPTED** mentor allocations

### Login Credentials

| Role | Email | Password |
|------|-------|----------|
| Super Admin | `superadmin@college.edu` | `password123` |
| Faculty 1 | `faculty1@gmail.com` | `password123` |
| Faculty 2 | `faculty2@gmail.com` | `password123` |
| Faculty 3 | `faculty3@gmail.com` | `password123` |
| Student 1-12 | `student1@gmail.com` ... `student12@gmail.com` | `password123` |

### Team Assignments

| Team | Members | Mentor |
|------|---------|--------|
| IT01 | Student 1, 2, 3 | Dr. Ramesh Kumar (Faculty 1) |
| IT02 | Student 4, 5, 6 | Dr. Priya Sharma (Faculty 2) |
| IT03 | Student 7, 8, 9 | Dr. Amit Patel (Faculty 3) |
| IT04 | Student 10, 11, 12 | Prof. Suresh Coordinator (Super Admin) |

### Testing Workflow

1. **Login as student** (e.g., student1@gmail.com)
2. Go to Project Progress
3. Submit topics and discuss with mentor
4. **Login as faculty** (e.g., faculty1@gmail.com)
5. View team topics, discuss, approve
6. **Login as admin** (superadmin@college.edu)
7. Roll out Review 1
8. Back to student: submit review progress
9. Faculty: provide feedback, complete review
10. Repeat for Review 2 and Final Review

---

## 11. Troubleshooting

### Common Issues

#### "User goes to login screen on reload"
**Cause**: Auth context loading state not handled  
**Solution**: All dashboard pages should check `authLoading` before redirecting

```typescript
if (authLoading) return <Loading />
if (!user) redirect('/auth/login')
```

#### "Faculty can't see student topics"
**Cause**: Using localStorage instead of API  
**Solution**: Faculty dashboard uses:
- `mentorAllocationApi.getAcceptedAllocations()`
- `projectTopicsApi.getTopicsByGroupId(groupId)`

#### "Review session not found"
**Cause**: Session endpoint requires specific group lookup  
**Solution**: Use `reviewsApi.getSessionByGroupId(reviewType, groupId)`

#### "Property groupId should not exist"
**Cause**: DTO change not picked up  
**Solution**: Restart backend server after DTO changes

#### Token expired / 401 errors
**Cause**: JWT expired or invalid  
**Solution**: api-client.ts automatically clears token on 401

### Debug Commands

```bash
# Check backend logs
cd server && npm run start:dev

# Check database
npx prisma studio

# Reset everything
npx prisma db push --force-reset
psql $DATABASE_URL -f seed-demo-data.sql
```

### API Testing

```bash
# Login
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"student1@gmail.com","password":"password123"}'

# Use token
curl http://localhost:3001/api/profiles/me \
  -H "Authorization: Bearer <token>"
```

---

## Quick Reference

### Environment Variables

**Backend (.env)**
```env
DATABASE_URL="postgresql://..."
DIRECT_URL="postgresql://..."
JWT_SECRET="min-32-character-secret"
```

**Frontend (.env.local)**
```env
NEXT_PUBLIC_API_URL=http://localhost:3001/api
```

### Key URLs

| Service | URL |
|---------|-----|
| Frontend | http://localhost:3000 |
| Backend API | http://localhost:3001/api |
| Prisma Studio | http://localhost:5555 |

---

*Last updated: January 2025*

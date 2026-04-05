# Project Overview

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Next.js App   │────▶│   NestJS API    │────▶│    Supabase     │
│   (Port 3000)   │     │   (Port 5000)   │     │   (PostgreSQL)  │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                        │
                                                        ▼
                                                ┌─────────────────┐
                                                │ Supabase Storage│
                                                │  (Attachments)  │
                                                └─────────────────┘
```

## User Roles & Capabilities

### Student (`role: 'student'`)
- Create or join project groups (max 4 members per group)
- Submit project topic for mentor approval
- Submit preferences for mentor selection (rank 3 faculty)
- Participate in Review 1, Review 2, and Final Review
- Upload project attachments (group leader only)
- View group progress and mentor feedback

### Faculty/Mentor (`role: 'faculty'`)
- Accept or reject mentor allocation requests
- Approve, reject, or request revision on project topics
- Provide feedback during reviews
- Set Google Meet links for review sessions
- View assigned teams and their progress

### Superadmin (`role: 'superadmin'`)
- Roll out mentor preference form to students
- Manually allocate mentors to groups
- Activate Review 1, Review 2, Final Review phases
- View all groups, mentors, and analytics
- Export data as CSV/PDF

## Key Workflows

### 1. Group Formation
```
Student creates group → Gets team code → Shares code → Others join → Group full (4 members)
```

### 2. Mentor Allocation
```
Admin rolls out form → Students submit 3 preferences → Auto-allocation runs → 
Faculty accepts/rejects → If rejected, try next preference
```

### 3. Topic Approval
```
Group leader submits topic → Mentor reviews → Approves/Rejects/Requests Revision
```

### 4. Reviews (R1, R2, Final)
```
Admin activates review → Students submit progress → Mentor provides feedback → 
Mark complete → Move to next review
```

## Database Schema Overview

### Core Models
- **Profile**: User info (student/faculty/superadmin), semester, department, domains
- **Group**: Project groups with team code, members, meet link
- **Topic**: Project topics with status (pending/approved/rejected/revision)
- **MentorPreference**: Student's ranked mentor choices
- **MentorAllocation**: Mentor-group assignments with status
- **ReviewSession**: Review progress per group per review type
- **ReviewMessage**: Comments/discussion during reviews
- **Attachment**: Uploaded files per group

### Important Enums
```typescript
// Roles
type Role = 'student' | 'faculty' | 'superadmin'

// Topic Status
type TopicStatus = 'pending' | 'approved' | 'rejected' | 'revision'

// Review Types
type ReviewType = 'review_1' | 'review_2' | 'final_review'

// Review Status
type ReviewStatus = 'not_started' | 'in_progress' | 'submitted' | 'feedback_given' | 'completed'

// Allocation Status
type AllocationStatus = 'pending' | 'accepted' | 'rejected'
```

## Environment Variables

### Client (`client/.env`)
```
NEXT_PUBLIC_API_URL=http://localhost:5000
NEXT_PUBLIC_SUPABASE_URL=<supabase-url>
NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon-key>
```

### Server (`server/.env`)
```
DATABASE_URL=<postgres-connection-string>
SUPABASE_URL=<supabase-url>
SUPABASE_SERVICE_ROLE_KEY=<service-role-key>
JWT_SECRET=<jwt-secret>
PORT=5000
```

## Deployment

- **Frontend**: Vercel or any Node.js host
- **Backend**: Render (current) or any Node.js host
- **Database**: Supabase (PostgreSQL)
- **Storage**: Supabase Storage

Note: Render free tier has cold starts causing slow initial API responses.

# Frontend Guide

## Tech Stack
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **UI Components**: shadcn/ui (Radix primitives)
- **Icons**: Lucide React
- **Auth**: Supabase Auth client

## Directory Structure

```
client/
├── app/
│   ├── layout.tsx              # Root layout with providers
│   ├── page.tsx                # Landing page
│   ├── login/page.tsx          # Login page
│   ├── register/page.tsx       # Registration page
│   └── dashboard/
│       ├── student/page.tsx    # Student dashboard (750+ lines)
│       ├── faculty/page.tsx    # Faculty dashboard (950+ lines)
│       └── admin/page.tsx      # Superadmin dashboard (600+ lines)
├── components/
│   ├── ui/                     # shadcn/ui components (button, card, dialog, etc.)
│   ├── attachments-tab.tsx     # File upload/download for projects
│   ├── manual-allocation-modal.tsx  # Admin mentor allocation dialog
│   ├── mentor-overview-panel.tsx    # Admin mentor/group overview
│   ├── review-tab.tsx          # Review submission and feedback
│   └── topic-tab.tsx           # Topic submission and approval
├── lib/
│   ├── api.ts                  # API service layer (all endpoints)
│   ├── api-client.ts           # Axios instance with auth
│   ├── supabase.ts             # Supabase client
│   ├── export-utils.ts         # CSV/PDF export utilities
│   └── utils.ts                # General utilities (cn, formatDate, etc.)
└── types/
    └── index.ts                # TypeScript interfaces
```

## Key Components

### Dashboard Pages

#### Student Dashboard (`app/dashboard/student/page.tsx`)
- **Tabs**: Overview, Topic, Review 1, Review 2, Final Review
- **Key State**:
  ```typescript
  const [group, setGroup] = useState<Group | null>(null)
  const [topic, setTopic] = useState<Topic | null>(null)
  const [reviewSession, setReviewSession] = useState<ReviewSession | null>(null)
  ```
- **Features**: Group creation/joining, topic submission, review progress

#### Faculty Dashboard (`app/dashboard/faculty/page.tsx`)
- **Tabs**: Overview, Pending Allocations, My Teams
- **Key State**:
  ```typescript
  const [pendingAllocations, setPendingAllocations] = useState<Allocation[]>([])
  const [myTeams, setMyTeams] = useState<Team[]>([])
  const [selectedTeam, setSelectedTeam] = useState<Team | null>(null)
  ```
- **Features**: Accept/reject allocations, view teams, approve topics, give feedback

#### Admin Dashboard (`app/dashboard/admin/page.tsx`)
- **Tabs**: Mentor & Group Overview, Form & Review Management
- **Key State**:
  ```typescript
  const [mentorOverview, setMentorOverview] = useState<MentorOverview[]>([])
  const [groups, setGroups] = useState<Group[]>([])
  const [formActive, setFormActive] = useState(false)
  ```
- **Features**: Mentor allocation, review rollout, analytics, CSV/PDF export

### Reusable Components

#### `attachments-tab.tsx` (314 lines)
- Handles file uploads for project stages
- 5MB file size limit
- Download and delete functionality
- Currently has predefined stages (topic_approval, review_1, review_2, final_review)

#### `mentor-overview-panel.tsx` (269 lines)
- Expandable mentor cards
- Group details with status badges
- Review progress indicators

#### `review-tab.tsx`
- Submit review progress (percentage + description)
- View mentor feedback
- Discussion thread

#### `topic-tab.tsx`
- Submit project topic (title + description)
- View approval status
- Mentor comments

## API Service Layer (`lib/api.ts`)

```typescript
// Authentication
authApi.login(email, password)
authApi.register(data)
authApi.getProfile()

// Groups
groupsApi.create(department)
groupsApi.join(teamCode)
groupsApi.getMyGroup()
groupsApi.getByDepartment(department)
groupsApi.getWithDetails(department)

// Topics
topicsApi.submit(data)
topicsApi.approve(topicId)
topicsApi.reject(topicId, reason)
topicsApi.requestRevision(topicId, feedback)
topicsApi.getByGroupId(groupId)

// Allocations
allocationsApi.submitPreferences(preferences)
allocationsApi.acceptAllocation(allocationId)
allocationsApi.rejectAllocation(allocationId)
allocationsApi.getMyAllocations()
allocationsApi.getPendingAllocations()

// Reviews
reviewsApi.rollout(reviewType)
reviewsApi.getRollout(reviewType)
reviewsApi.submitProgress(reviewType, data)
reviewsApi.submitFeedback(sessionId, feedback)
reviewsApi.markComplete(sessionId)
reviewsApi.getMySession(reviewType)
reviewsApi.getSessionByGroupId(reviewType, groupId)

// Attachments
attachmentsApi.upload(stage, file)
attachmentsApi.getMyGroupAttachments()
attachmentsApi.getByGroupId(groupId)
attachmentsApi.delete(id)

// Admin
adminApi.getMentorOverview()
adminApi.getUnassignedGroups()
adminApi.getAvailableMentors()
adminApi.allocateMentor(groupId, mentorId)
```

## State Management

- Uses React `useState` and `useEffect` for local state
- No global state manager (Redux, Zustand, etc.)
- Data fetched in `useEffect` on component mount
- **Current Issue**: No caching - re-fetches on every tab switch

## UI Patterns

### Loading States (Current - Inconsistent)
```tsx
{loading ? <p>Loading...</p> : <Content />}
```

### Error Handling
```tsx
try {
  const data = await api.someCall()
  setData(data)
} catch (error) {
  toast.error("Something went wrong")
}
```

### Tab Navigation (shadcn/ui Tabs)
```tsx
<Tabs value={activeTab} onValueChange={setActiveTab}>
  <TabsList>
    <TabsTrigger value="overview">Overview</TabsTrigger>
    <TabsTrigger value="details">Details</TabsTrigger>
  </TabsList>
  <TabsContent value="overview">...</TabsContent>
  <TabsContent value="details">...</TabsContent>
</Tabs>
```

## Common Imports

```typescript
// UI Components
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Badge } from "@/components/ui/badge"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"

// Icons
import { Plus, Check, X, Upload, Download, Trash2, Users, FileText } from "lucide-react"

// API
import { groupsApi, topicsApi, reviewsApi, attachmentsApi } from "@/lib/api"

// Utils
import { cn } from "@/lib/utils"
```

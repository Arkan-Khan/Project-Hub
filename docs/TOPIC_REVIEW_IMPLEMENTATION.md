# Topic Approval & Review System - Implementation Progress

## Overview
Building a chat-like interface for topic submission/approval and review progress tracking. Students submit topics and progress updates; mentors discuss and approve. Super admin rolls out review phases.

---

## Implementation Checklist

### Phase 1: Foundation
- [x] Add new types to `types/index.ts`
- [x] Create UI components (Dialog, Textarea, Badge, ScrollArea, Avatar, Separator, Tabs)
- [x] Add mock storage functions to `lib/storage.ts`

### Phase 2: Core Components
- [x] Create `ThreadPanel` component (reusable message thread)
- [x] Create `TopicApprovalSection` component
- [x] Create `ReviewSection` component

### Phase 3: Pages & Integration
- [x] Create `/dashboard/student/project-progress/page.tsx`
- [x] Update student dashboard with Project Progress card
- [x] Update faculty dashboard with project progress section
- [x] Update admin dashboard with review rollout controls

---

## New Types Added

```typescript
// Topic Approval Types
ProjectTopic, TopicMessage, TopicStatus

// Review Types  
ReviewSession, ReviewMessage, ReviewRollout, ReviewType

// Progress Tracking
TeamProgress
```

---

## New Components Created

| Component | Location | Purpose |
|-----------|----------|---------|
| `Dialog` | `components/ui/dialog.tsx` | Modal overlay |
| `Textarea` | `components/ui/textarea.tsx` | Multi-line input |
| `Badge` | `components/ui/badge.tsx` | Status indicators |
| `ScrollArea` | `components/ui/scroll-area.tsx` | Scrollable container |
| `Avatar` | `components/ui/avatar.tsx` | User profile images |
| `Tabs` | `components/ui/tabs.tsx` | Tab navigation |
| `ThreadPanel` | `components/thread-panel.tsx` | Reusable chat thread |
| `TopicApprovalSection` | `components/topic-approval-section.tsx` | Topic submission & approval |
| `ReviewSection` | `components/review-section.tsx` | Review progress & feedback |

---

## Storage Functions Added

```typescript
// Topic Approval
createTopic(groupId, title, description, submittedBy)
getTopicsByGroup(groupId)
addTopicMessage(topicId, authorId, authorName, content, role)
approveTopic(topicId, mentorId)
rejectAllTopics(groupId, mentorId)

// Reviews
rolloutReview(department, reviewType, createdBy)
getActiveReviewRollout(department, reviewType)
createReviewSession(groupId, reviewType, percentage, description, submittedBy)
getReviewSession(groupId, reviewType)
addReviewMessage(sessionId, authorId, authorName, content, role)

// Progress
getTeamProgress(groupId)
```

---

## UI Flow

### Student Journey
1. **Mentor Allocated** → Topic Approval section unlocks
2. **Submit Topics** → Add up to 3 topics with title + description
3. **Discussion** → Chat with mentor about topics
4. **Topic Approved** → Review 1 tab shows (locked until admin rollout)
5. **Review 1 Active** → Submit progress % + description, discuss with mentor
6. **Review 2 Active** → Submit updated progress, get suggestions
7. **Final Review** → Mark project complete

### Faculty Journey
1. **View Mentored Teams** → See all teams with progress status
2. **Click Team** → Open modal with team's thread
3. **Topic Review** → Discuss topics, approve one or request new
4. **Review Sessions** → Read progress, add suggestions

### Admin Journey
1. **Review Rollout** → Activate Review 1/2/Final for department
2. **Monitor Progress** → Overview of all teams' status

---

## Implementation Log

### Session 1 - January 16, 2026
- Created this progress document
- Planning complete, starting implementation
- Added new types: `ProjectTopic`, `TopicMessage`, `ReviewSession`, `ReviewMessage`, `ReviewRollout`, `TeamProgress`
- Created UI components: Dialog, Textarea, Badge, ScrollArea, Avatar, Tabs, Separator
- Created core components: ThreadPanel, TopicApprovalSection, ReviewSection
- Added 20+ storage functions for topics, reviews, and progress tracking
- Created student project-progress page with tabs for Topic Approval, Review 1, Review 2, Final Review
- Updated student dashboard with Project Progress card (visible after mentor allocation)
- Updated faculty dashboard with Project Progress section showing all mentored teams with status chips
- Added team dialog with full topic/review management for faculty
- Updated admin dashboard with Review Rollout controls (activate Review 1, 2, Final)
- Enhanced Groups Overview table with Topic, R1, R2, Final columns

**Implementation Complete!** ✅

---

## Notes
- Using localStorage for mock data (ready for API replacement)
- No real-time updates - manual refresh for now
- Links supported in messages, file uploads deferred
- Review phases must be activated sequentially (R1 → R2 → Final)

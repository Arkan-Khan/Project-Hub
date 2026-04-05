# File Map - Quick Reference

## Common Tasks → File Locations

### Dashboard Pages
| Task | File |
|------|------|
| Edit student dashboard | `client/app/dashboard/student/page.tsx` |
| Edit faculty dashboard | `client/app/dashboard/faculty/page.tsx` |
| Edit admin dashboard | `client/app/dashboard/admin/page.tsx` |
| Edit login page | `client/app/login/page.tsx` |
| Edit registration | `client/app/register/page.tsx` |

### UI Components
| Task | File |
|------|------|
| Attachments upload/download | `client/components/attachments-tab.tsx` |
| Mentor allocation modal | `client/components/manual-allocation-modal.tsx` |
| Mentor/group overview table | `client/components/mentor-overview-panel.tsx` |
| Review submission/feedback | `client/components/review-tab.tsx` |
| Topic submission/approval | `client/components/topic-tab.tsx` |
| All shadcn UI components | `client/components/ui/*.tsx` |

### API & Data
| Task | File |
|------|------|
| Frontend API calls | `client/lib/api.ts` |
| Axios client config | `client/lib/api-client.ts` |
| Supabase client | `client/lib/supabase.ts` |
| CSV/PDF export | `client/lib/export-utils.ts` |
| TypeScript types | `client/types/index.ts` |

### Backend Controllers
| Task | File |
|------|------|
| Auth (login, register) | `server/src/auth/auth.controller.ts` |
| Groups (create, join) | `server/src/groups/groups.controller.ts` |
| Topics (submit, approve) | `server/src/topics/topics.controller.ts` |
| Allocations (preferences) | `server/src/allocations/allocations.controller.ts` |
| Reviews (progress, feedback) | `server/src/reviews/reviews.controller.ts` |
| Attachments (upload, delete) | `server/src/attachments/attachments.controller.ts` |
| Admin operations | `server/src/admin/admin.controller.ts` |

### Backend Services (Business Logic)
| Task | File |
|------|------|
| Auth logic | `server/src/auth/auth.service.ts` |
| Group logic | `server/src/groups/groups.service.ts` |
| Topic logic | `server/src/topics/topics.service.ts` |
| Allocation logic | `server/src/allocations/allocations.service.ts` |
| Review logic | `server/src/reviews/reviews.service.ts` |
| Attachment logic | `server/src/attachments/attachments.service.ts` |
| Admin logic | `server/src/admin/admin.service.ts` |

### Database
| Task | File |
|------|------|
| Database schema | `server/prisma/schema.prisma` |
| Prisma client | `server/src/prisma/prisma.service.ts` |
| Migrations | `server/prisma/migrations/` |

### Configuration
| Task | File |
|------|------|
| Frontend env vars | `client/.env` |
| Backend env vars | `server/.env` |
| Next.js config | `client/next.config.js` |
| Tailwind config | `client/tailwind.config.ts` |
| TypeScript (frontend) | `client/tsconfig.json` |
| TypeScript (backend) | `server/tsconfig.json` |
| NestJS config | `server/nest-cli.json` |

---

## Key Line References

### Admin Dashboard (`client/app/dashboard/admin/page.tsx`)
- Tab state: Line 44
- Mentor overview fetch: Line 136
- Tab rendering: Lines 284-288
- Form & Review Management tab: Lines 295-580
- Review rollout cards: Lines 412-528
- Groups overview table: Lines 530-580

### Faculty Dashboard (`client/app/dashboard/faculty/page.tsx`)
- Tab state: Line 54
- My Teams section: Lines 570-623
- Team member display: Lines 603-617
- Project progress cards: Lines 625-750

### Mentor Overview Panel (`client/components/mentor-overview-panel.tsx`)
- MentorCard component: Lines 79-169
- GroupRow component: Lines 171-241
- Topic status badge: ~Line 195
- Export buttons triggered from: Lines 170-180 in admin/page.tsx

### Export Utils (`client/lib/export-utils.ts`)
- CSV generation: Lines 41-110
- PDF generation: Lines 132-230
- Download helpers: Lines 115-127, 235-252

### Attachments Tab (`client/components/attachments-tab.tsx`)
- Stage definitions: Lines 29-50
- File size limit (5MB): Line 52
- StageCard component: Lines 73-232
- Upload logic: ~Lines 100-150
- Delete logic: ~Lines 160-190

### Prisma Schema (`server/prisma/schema.prisma`)
- Profile model: Lines 42-64
- Group model: Lines 67-83
- Topic model: Lines 120-140
- MentorAllocation: Lines 180-200
- ReviewSession: Lines 252-271
- Attachment: Lines 298-311
- Semester field: Line 50 (in Profile)

---

## Component Dependencies

```
admin/page.tsx
├── manual-allocation-modal.tsx
├── mentor-overview-panel.tsx
└── lib/export-utils.ts

faculty/page.tsx
├── review-tab.tsx
├── topic-tab.tsx
└── attachments-tab.tsx

student/page.tsx
├── review-tab.tsx
├── topic-tab.tsx
└── attachments-tab.tsx
```

---

## API to Frontend Mapping

| Frontend Function | Backend Endpoint |
|-------------------|------------------|
| `groupsApi.create()` | POST `/groups/create` |
| `groupsApi.join()` | POST `/groups/join` |
| `groupsApi.getMyGroup()` | GET `/groups/my-group` |
| `topicsApi.submit()` | POST `/topics/submit` |
| `topicsApi.approve()` | POST `/topics/:id/approve` |
| `allocationsApi.submitPreferences()` | POST `/allocations/preferences` |
| `allocationsApi.acceptAllocation()` | POST `/allocations/:id/accept` |
| `reviewsApi.rollout()` | POST `/reviews/rollout` |
| `reviewsApi.submitProgress()` | POST `/reviews/submit/:reviewType` |
| `reviewsApi.submitFeedback()` | POST `/reviews/feedback/:sessionId` |
| `attachmentsApi.upload()` | POST `/attachments/upload/:stage` |
| `attachmentsApi.delete()` | DELETE `/attachments/:id` |
| `adminApi.getMentorOverview()` | GET `/admin/mentor-overview` |
| `adminApi.allocateMentor()` | POST `/admin/allocate-mentor` |

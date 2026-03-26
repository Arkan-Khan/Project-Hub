# New Features - March 2026

## Overview

Four major features were added to ProjectHub to enhance super admin capabilities and student project submissions:

1. **Mentor & Group Overview Panel** - Comprehensive dashboard showing all mentors, their groups, and progress
2. **Export Functionality** - CSV and PDF export of mentor/group data
3. **Manual Mentor Allocation** - Direct admin assignment for unallocated groups
4. **File Attachments** - Student file uploads per review stage via Supabase Storage

---

## 1. Mentor & Group Overview Panel

### Description
Admin dashboard tab showing expandable cards for each mentor with:
- Assigned groups
- Topic approval status
- Review progress (R1, R2, Final)

### Location
Admin Dashboard → "Mentor & Group Overview" tab

### API Endpoint
```
GET /api/admin/mentor-overview
```

### Response Type
```typescript
interface MentorOverview {
  id: string;
  name: string;
  email: string;
  department: Department;
  role: "faculty" | "super_admin";
  domains: string | null;
  assignedGroups: MentorGroupInfo[];
}
```

### Files
- Backend: `server/src/admin/admin.service.ts`
- Frontend: `client/components/mentor-overview-panel.tsx`

---

## 2. Export Functionality (CSV & PDF)

### Description
Export buttons in admin toolbar to download mentor/group data as CSV or PDF.

### Export Formats
- **CSV**: Spreadsheet-friendly format
- **PDF**: Formatted report with tables

### Usage
```typescript
import { exportMentorOverviewCSV, exportMentorOverviewPDF } from "@/lib/export-utils";

exportMentorOverviewCSV(mentors);  // Downloads CSV
exportMentorOverviewPDF(mentors);  // Downloads PDF
```

### Dependencies
```json
{
  "jspdf": "^2.5.2",
  "jspdf-autotable": "^3.8.4"
}
```

### Files
- `client/lib/export-utils.ts`

---

## 3. Manual Mentor Allocation

### Description
Modal for super admins to manually assign mentors to groups that don't have allocations.

### Use Cases
- Late-joining groups
- Groups with all preferences rejected
- Direct admin assignment

### API Endpoints

#### Get Unassigned Groups
```
GET /api/admin/unassigned-groups
```

#### Get Available Mentors
```
GET /api/admin/available-mentors
```

#### Allocate Mentor
```
POST /api/admin/allocate-mentor
Body: {
  "groupId": "uuid",
  "mentorId": "uuid"
}
```

### Files
- Backend: `server/src/admin/admin.controller.ts`, `admin.service.ts`
- Frontend: `client/components/manual-allocation-modal.tsx`

---

## 4. File Attachments (Supabase Storage)

### Description
Students can upload files for each review stage. Only group leaders can upload.

### Stages
- Topic Approval
- Review 1
- Review 2
- Final Review

### Constraints
- **Max file size**: 5 MB
- **One file per stage per group**
- **Allowed types**: PDF, Word, PowerPoint, Excel, images, ZIP, RAR, TXT
- **Permission**: Leader only

### API Endpoints

#### Upload File
```
POST /api/attachments/upload
Content-Type: multipart/form-data

Fields:
- file: File
- groupId: string (UUID)
- stage: "topic_approval" | "review_1" | "review_2" | "final_review"
```

#### List Group Attachments
```
GET /api/attachments/group/:groupId
```

#### Delete Attachment
```
DELETE /api/attachments/:id
```

### Database Schema
```prisma
model Attachment {
  id          String          @id @default(uuid())
  groupId     String
  stage       AttachmentStage
  filename    String
  fileUrl     String
  fileSize    Int
  mimeType    String
  uploadedBy  String
  uploadedAt  DateTime        @default(now())
  
  @@unique([groupId, stage])
}

enum AttachmentStage {
  topic_approval
  review_1
  review_2
  final_review
}
```

### Environment Setup

#### Backend (.env)
```env
SUPABASE_URL="https://[project-ref].supabase.co"
SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"
SUPABASE_STORAGE_BUCKET="project-attachments"
```

#### Supabase Setup
1. Go to Supabase Dashboard → Storage
2. Create bucket: `project-attachments`
3. Set to Public (or configure RLS policies)

### Files
- Backend:
  - `server/src/supabase/supabase.service.ts` - Supabase client
  - `server/src/attachments/attachments.controller.ts` - API endpoints
  - `server/src/attachments/attachments.service.ts` - Business logic
- Frontend:
  - `client/components/attachments-tab.tsx` - Upload UI
  - `client/lib/api.ts` - API functions with FormData support

---

## Testing

### Seed Data

The updated `seed-demo-data.sql` includes:
- **18 students** (6 teams)
- **2 unassigned groups** (IT05, IT06) for testing manual allocation
- **Sample attachments** for IT01 and IT02
- **Project topics** with different statuses
- **Review sessions** with progress data

### Test Credentials
All passwords: `password`

| Role | Email |
|------|-------|
| Super Admin | superadmin@gmail.com |
| Faculty | faculty1@gmail.com, faculty2@gmail.com, faculty3@gmail.com |
| Students | student1@gmail.com ... student18@gmail.com |

### Testing Steps

#### 1. Mentor Overview & Export
```
1. Login: superadmin@gmail.com / password
2. Admin Dashboard → "Mentor & Group Overview"
3. View expandable mentor cards
4. Click "Export CSV" or "Export PDF"
```

#### 2. Manual Allocation
```
1. Admin Dashboard → Click "Manual Allocation" button
2. Badge shows "2" (IT05, IT06 unassigned)
3. Select a group
4. Choose a mentor
5. Confirm allocation
```

#### 3. File Attachments
```
1. Login: student1@gmail.com / password (IT01 leader)
2. Dashboard → Project Progress → Attachments tab
3. See existing attachments
4. Upload a file (≤5MB)
5. Login as student2 → Verify upload disabled (non-leader)
```

---

## Migration Guide

### Database Migration
```bash
cd server
npx prisma db push
```

### Install Dependencies

#### Backend
```bash
cd server
npm install @supabase/supabase-js
npm install -D @types/multer
```

#### Frontend
```bash
cd client
npm install jspdf jspdf-autotable
npm install -D @types/jspdf
```

### Environment Variables

Add to `server/.env`:
```env
SUPABASE_URL="https://[project-ref].supabase.co"
SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"
SUPABASE_STORAGE_BUCKET="project-attachments"
```

### Seed Database
Run `server/seed-demo-data.sql` in Supabase SQL Editor

---

## Architecture Changes

### New Backend Modules
- `src/admin/` - Admin features (overview, manual allocation)
- `src/supabase/` - Supabase client and storage operations
- `src/attachments/` - File upload handling

### New Frontend Components
- `components/mentor-overview-panel.tsx` - Admin overview UI
- `components/manual-allocation-modal.tsx` - Allocation modal
- `components/attachments-tab.tsx` - File upload interface
- `lib/export-utils.ts` - CSV/PDF generation

### Updated Files
- `server/prisma/schema.prisma` - Added Attachment model
- `server/src/app.module.ts` - Registered new modules
- `client/types/index.ts` - Added new TypeScript types
- `client/lib/api.ts` - Added admin and attachment APIs
- `client/lib/api-client.ts` - Added FormData upload support

---

## Troubleshooting

### "Property groupId should not exist"
**Solution**: Restart backend server. DTO changes require server restart.

### "File upload fails"
**Solution**: 
1. Verify Supabase bucket exists
2. Check environment variables
3. Restart backend

### "Only leader can upload"
**Solution**: This is expected. Only the group creator can upload files.

### "Manual allocation validation errors"
**Solution**: Ensure class-validator decorators are present in DTO and restart server.

---

## Future Enhancements

Potential improvements:
- Multiple files per stage
- File versioning
- Direct file viewing in UI
- Batch allocation interface
- Advanced export filters
- Email notifications for uploads

---

*Last Updated: March 26, 2026*

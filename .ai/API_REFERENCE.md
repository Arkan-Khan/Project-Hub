# API Reference

Base URL: `http://localhost:5000` (dev) or deployed server URL

## Authentication

All protected routes require JWT token in Authorization header:
```
Authorization: Bearer <token>
```

---

## Auth Endpoints

### POST /auth/register
Register new user.
```json
// Request
{
  "email": "student@example.com",
  "password": "password123",
  "name": "John Doe",
  "role": "student",
  "department": "IT",
  "rollNumber": "21IT001",  // required for students
  "semester": 6             // required for students
}

// Response
{
  "id": "uuid",
  "email": "student@example.com",
  "name": "John Doe",
  "role": "student"
}
```

### POST /auth/login
```json
// Request
{ "email": "user@example.com", "password": "password123" }

// Response
{
  "token": "jwt-token",
  "user": { "id": "uuid", "name": "John", "role": "student" }
}
```

### GET /auth/profile
Get current user's profile. Requires auth.

---

## Groups Endpoints

### POST /groups/create
Create new group. Requires auth (student).
```json
// Request
{ "department": "IT" }

// Response
{
  "id": "uuid",
  "groupId": "IT03",
  "teamCode": "A7DXQ",
  "department": "IT",
  "createdBy": "profile-uuid"
}
```

### POST /groups/join
Join existing group by team code. Requires auth.
```json
// Request
{ "teamCode": "A7DXQ" }

// Response
{ "success": true, "group": { ... } }
```

### GET /groups/my-group
Get current user's group with members. Requires auth.
```json
// Response
{
  "id": "uuid",
  "groupId": "IT03",
  "teamCode": "A7DXQ",
  "members": [
    { "id": "uuid", "name": "John Doe", "rollNumber": "21IT001" }
  ],
  "topic": { "title": "...", "status": "approved" },
  "mentor": { "name": "Dr. Smith", "email": "..." }
}
```

### GET /groups/with-details/:department
Get all groups with full details. Used by admin dashboard.

---

## Topics Endpoints

### POST /topics/submit
Submit project topic. Requires auth (group leader).
```json
// Request
{ "title": "AI-based Attendance System", "description": "..." }

// Response
{ "id": "uuid", "title": "...", "status": "pending" }
```

### POST /topics/:id/approve
Approve topic. Requires auth (mentor).

### POST /topics/:id/reject
Reject topic. Requires auth (mentor).
```json
// Request
{ "reason": "Topic too broad, please narrow scope" }
```

### POST /topics/:id/revision
Request revision. Requires auth (mentor).
```json
// Request
{ "feedback": "Please add more technical details" }
```

### GET /topics/group/:groupId
Get topic by group ID.

---

## Allocations Endpoints

### POST /allocations/preferences
Submit mentor preferences. Requires auth (group leader).
```json
// Request
{
  "preferences": [
    { "mentorId": "uuid1", "rank": 1 },
    { "mentorId": "uuid2", "rank": 2 },
    { "mentorId": "uuid3", "rank": 3 }
  ]
}
```

### POST /allocations/:id/accept
Accept allocation. Requires auth (faculty).

### POST /allocations/:id/reject
Reject allocation. Requires auth (faculty).

### GET /allocations/my-allocations
Get faculty's accepted allocations (teams).

### GET /allocations/pending
Get faculty's pending allocation requests.

---

## Reviews Endpoints

### POST /reviews/rollout
Activate review phase. Requires auth (admin).
```json
// Request
{ "reviewType": "review_1" }  // review_1, review_2, or final_review
```

### GET /reviews/rollout/:reviewType
Check if review phase is active.
```json
// Response
{ "active": true }
```

### POST /reviews/submit/:reviewType
Submit review progress. Requires auth (student).
```json
// Request
{
  "progressPercentage": 45,
  "progressDescription": "Completed database design and API structure"
}
```

### POST /reviews/feedback/:sessionId
Submit mentor feedback. Requires auth (faculty).
```json
// Request
{ "feedback": "Good progress. Focus on testing next." }
```

### PATCH /reviews/:sessionId/complete
Mark review as complete. Requires auth (faculty).

### PATCH /reviews/:sessionId/meet-link
Set Google Meet link for review session.
```json
// Request
{ "meetLink": "https://meet.google.com/abc-defg-hij" }
```

### GET /reviews/session/:reviewType
Get current user's review session.

### GET /reviews/session/:reviewType/group/:groupId
Get specific group's review session.

### POST /reviews/messages
Add message to review discussion.
```json
// Request
{ "sessionId": "uuid", "content": "Can we schedule a meeting?" }
```

### GET /reviews/messages/session/:sessionId
Get all messages for a review session.

---

## Attachments Endpoints

### POST /attachments/upload/:stage
Upload file attachment. Multipart form data.
- Max file size: 5MB
- Allowed types: PDF, Word, PowerPoint, Excel, images, ZIP, RAR, TXT
```
// Form data
file: <file>
stage: topic_approval | review_1 | review_2 | final_review
```

### GET /attachments/my-group
Get current group's attachments.
```json
// Response
[
  {
    "id": "uuid",
    "stage": "review_1",
    "filename": "progress-report.pdf",
    "fileUrl": "https://...",
    "fileSize": 1234567,
    "uploadedAt": "2024-01-15T10:30:00Z"
  }
]
```

### GET /attachments/group/:groupId
Get specific group's attachments. Used by mentors.

### DELETE /attachments/:id
Delete attachment. Requires auth (uploader or group leader).

---

## Admin Endpoints

### GET /admin/mentor-overview
Get all mentors with their groups and review progress.
```json
// Response
[
  {
    "mentorId": "uuid",
    "mentorName": "Dr. Smith",
    "mentorEmail": "smith@college.edu",
    "domains": "AI, ML",
    "groups": [
      {
        "groupId": "IT03",
        "teamCode": "A7DXQ",
        "leader": { "name": "John", "rollNumber": "21IT001" },
        "members": [...],
        "topicStatus": "approved",
        "topicTitle": "AI Attendance",
        "review1": { "status": "completed", "progress": 100 },
        "review2": { "status": "in_progress", "progress": 60 },
        "finalReview": { "status": "not_started", "progress": 0 }
      }
    ]
  }
]
```

### GET /admin/unassigned-groups
Get groups without accepted mentor.

### GET /admin/available-mentors
Get faculty available for manual allocation.

### POST /admin/allocate-mentor
Manually allocate mentor to group.
```json
// Request
{ "groupId": "uuid", "mentorId": "uuid" }
```

---

## Error Responses

All errors follow this format:
```json
{
  "statusCode": 400,
  "message": "Error description",
  "error": "Bad Request"
}
```

Common status codes:
- `400` - Bad Request (validation error)
- `401` - Unauthorized (missing/invalid token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found
- `500` - Internal Server Error

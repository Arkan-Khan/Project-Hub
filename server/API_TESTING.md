# API Testing Guide

Quick guide to test the ProjectHub backend API.

## Prerequisites

- Server running on `http://localhost:3001`
- A tool like `curl`, Postman, or Thunder Client (VS Code extension)

## Test Flow

### 1. Create a Student Account

**Sign up:**
```bash
curl -X POST http://localhost:3001/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student1@test.com",
    "password": "password123"
  }'
```

**Response:**
```json
{
  "user": {
    "id": "uuid-here",
    "email": "student1@test.com",
    "createdAt": "2026-01-16T..."
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Save the token!** You'll need it for subsequent requests.

### 2. Complete Onboarding (Create Profile)

```bash
curl -X POST http://localhost:3001/api/profiles \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "name": "John Doe",
    "email": "student1@test.com",
    "role": "student",
    "department": "IT",
    "rollNumber": "IT2023001",
    "semester": 5
  }'
```

### 3. Create a Group

```bash
curl -X POST http://localhost:3001/api/groups/create \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Response:**
```json
{
  "id": "uuid",
  "groupId": "IT01",
  "teamCode": "A7DXQ",
  "department": "IT",
  "createdBy": "profile-id",
  "isFull": false,
  "members": [...]
}
```

**Save the teamCode** to test joining a group!

### 4. Create Another Student and Join the Group

**Sign up second student:**
```bash
curl -X POST http://localhost:3001/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student2@test.com",
    "password": "password123"
  }'
```

**Create profile:**
```bash
curl -X POST http://localhost:3001/api/profiles \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer STUDENT2_TOKEN" \
  -d '{
    "name": "Jane Smith",
    "email": "student2@test.com",
    "role": "student",
    "department": "IT",
    "rollNumber": "IT2023002",
    "semester": 5
  }'
```

**Join the group:**
```bash
curl -X POST http://localhost:3001/api/groups/join \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer STUDENT2_TOKEN" \
  -d '{
    "teamCode": "A7DXQ"
  }'
```

### 5. Create a Faculty Account

```bash
curl -X POST http://localhost:3001/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "faculty1@test.com",
    "password": "password123"
  }'
```

**Create faculty profile:**
```bash
curl -X POST http://localhost:3001/api/profiles \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer FACULTY_TOKEN" \
  -d '{
    "name": "Dr. Sarah Johnson",
    "email": "faculty1@test.com",
    "role": "faculty",
    "department": "IT"
  }'
```

### 6. Create a Super Admin Account

```bash
curl -X POST http://localhost:3001/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@test.com",
    "password": "password123"
  }'
```

**Create admin profile (requires access code):**
```bash
curl -X POST http://localhost:3001/api/profiles \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -d '{
    "name": "IT Coordinator",
    "email": "admin@test.com",
    "role": "super_admin",
    "department": "IT",
    "accessCode": "ITADMIN2025"
  }'
```

### 7. Get Available Faculty

```bash
curl -X GET http://localhost:3001/api/profiles/faculty/IT \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 8. Roll Out Mentor Allocation Form (Super Admin)

```bash
curl -X POST http://localhost:3001/api/mentor-forms \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -d '{
    "availableMentorIds": ["faculty-profile-id-1", "faculty-profile-id-2"]
  }'
```

**Save the form ID from the response!**

### 9. Submit Mentor Preferences (Group Leader)

```bash
curl -X POST http://localhost:3001/api/mentor-preferences \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer STUDENT1_TOKEN" \
  -d '{
    "formId": "form-id-here",
    "mentorChoices": [
      "mentor-id-1",
      "mentor-id-2",
      "mentor-id-3"
    ]
  }'
```

### 10. View Allocations (Faculty)

```bash
curl -X GET http://localhost:3001/api/mentor-allocations/for-mentor \
  -H "Authorization: Bearer FACULTY_TOKEN"
```

### 11. Accept a Team (Faculty)

```bash
curl -X POST http://localhost:3001/api/mentor-allocations/ALLOCATION_ID/accept \
  -H "Authorization: Bearer FACULTY_TOKEN"
```

### 12. Check Mentor Status (Student)

```bash
curl -X GET http://localhost:3001/api/mentor-allocations/status \
  -H "Authorization: Bearer STUDENT1_TOKEN"
```

## Common Endpoints to Test

### Get My Profile
```bash
curl -X GET http://localhost:3001/api/profiles/me \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Get My Group
```bash
curl -X GET http://localhost:3001/api/groups/my-group \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Get Active Form
```bash
curl -X GET http://localhost:3001/api/mentor-forms/active \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Get Current User Info
```bash
curl -X GET http://localhost:3001/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Access Codes for Testing

For super admin registration:
- **IT**: `ITADMIN2025`
- **CS**: `CSADMIN2025`
- **ECS**: `ECSADMIN2025`
- **ETC**: `ETCADMIN2025`
- **BM**: `BMADMIN2025`

## Tips

1. **Save tokens**: Keep each user's JWT token for testing different roles
2. **Use Postman/Thunder Client**: Much easier than curl for complex testing
3. **Check Prisma Studio**: View database changes in real-time with `npm run db:studio`
4. **Check Supabase**: Verify data in the Supabase Table Editor

## Expected Error Responses

### Invalid token
```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

### Validation error
```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "error": "Bad Request"
}
```

### Already in group
```json
{
  "statusCode": 400,
  "message": "You are already a member of a group"
}
```

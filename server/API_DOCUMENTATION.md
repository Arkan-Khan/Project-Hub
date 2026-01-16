# ProjectHub API Documentation

Complete API reference for the ProjectHub backend.

**Base URL:** `http://localhost:3001/api`

**Authentication:** All protected endpoints require JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

---

## Table of Contents

1. [Authentication](#authentication)
2. [Profiles](#profiles)
3. [Groups](#groups)
4. [Mentor Forms](#mentor-forms)
5. [Mentor Preferences](#mentor-preferences)
6. [Mentor Allocations](#mentor-allocations)
7. [Error Responses](#error-responses)

---

## Authentication

### Sign Up

Create a new user account.

**Endpoint:** `POST /auth/signup`  
**Auth Required:** No

**Request Body:**
```json
{
  "email": "student@test.com",
  "password": "password123"
}
```

**Response:** `200 OK`
```json
{
  "user": {
    "id": "uuid-here",
    "email": "student@test.com",
    "createdAt": "2026-01-16T12:00:00.000Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Errors:**
- `409 Conflict` - User already exists
- `400 Bad Request` - Validation error

---

### Log In

Authenticate existing user.

**Endpoint:** `POST /auth/login`  
**Auth Required:** No

**Request Body:**
```json
{
  "email": "student@test.com",
  "password": "password123"
}
```

**Response:** `200 OK`
```json
{
  "user": {
    "id": "uuid-here",
    "email": "student@test.com",
    "createdAt": "2026-01-16T12:00:00.000Z"
  },
  "profile": {
    "id": "profile-uuid",
    "userId": "user-uuid",
    "name": "John Doe",
    "email": "student@test.com",
    "role": "student",
    "department": "IT",
    "rollNumber": "IT2023001",
    "semester": 5,
    "createdAt": "2026-01-16T12:00:00.000Z",
    "updatedAt": "2026-01-16T12:00:00.000Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Notes:**
- `profile` will be `null` if user hasn't completed onboarding
- Store the `token` for subsequent API calls

**Errors:**
- `401 Unauthorized` - Invalid credentials

---

### Get Current User

Get currently authenticated user's details.

**Endpoint:** `GET /auth/me`  
**Auth Required:** Yes

**Response:** `200 OK`
```json
{
  "user": {
    "id": "uuid-here",
    "email": "student@test.com",
    "createdAt": "2026-01-16T12:00:00.000Z"
  },
  "profile": {
    "id": "profile-uuid",
    "name": "John Doe",
    "role": "student",
    "department": "IT",
    ...
  }
}
```

---

## Profiles

### Create Profile

Complete user onboarding by creating a profile.

**Endpoint:** `POST /profiles`  
**Auth Required:** Yes

**Request Body (Student):**
```json
{
  "name": "John Doe",
  "email": "student@test.com",
  "role": "student",
  "department": "IT",
  "rollNumber": "IT2023001",
  "semester": 5
}
```

**Request Body (Faculty):**
```json
{
  "name": "Dr. Sarah Johnson",
  "email": "faculty@test.com",
  "role": "faculty",
  "department": "IT"
}
```

**Request Body (Super Admin):**
```json
{
  "name": "IT Coordinator",
  "email": "admin@test.com",
  "role": "super_admin",
  "department": "IT",
  "accessCode": "ITADMIN2025"
}
```

**Response:** `200 OK`
```json
{
  "id": "profile-uuid",
  "userId": "user-uuid",
  "name": "John Doe",
  "email": "student@test.com",
  "role": "student",
  "department": "IT",
  "rollNumber": "IT2023001",
  "semester": 5,
  "createdAt": "2026-01-16T12:00:00.000Z",
  "updatedAt": "2026-01-16T12:00:00.000Z"
}
```

**Validation Rules:**
- `name`: Required, string
- `email`: Required, valid email
- `role`: Required, one of: `student`, `faculty`, `super_admin`
- `department`: Required, one of: `IT`, `CS`, `ECS`, `ETC`, `BM`
- `rollNumber`: Required for students only
- `semester`: Required for students only (1-8)
- `accessCode`: Required for super_admin role

**Access Codes:**
- IT: `ITADMIN2025`
- CS: `CSADMIN2025`
- ECS: `ECSADMIN2025`
- ETC: `ETCADMIN2025`
- BM: `BMADMIN2025`

**Errors:**
- `400 Bad Request` - Invalid access code or missing required fields
- `409 Conflict` - Profile already exists for this user

---

### Get My Profile

Get current user's profile.

**Endpoint:** `GET /profiles/me`  
**Auth Required:** Yes

**Response:** `200 OK`
```json
{
  "id": "profile-uuid",
  "userId": "user-uuid",
  "name": "John Doe",
  "email": "student@test.com",
  "role": "student",
  "department": "IT",
  "rollNumber": "IT2023001",
  "semester": 5,
  "createdAt": "2026-01-16T12:00:00.000Z",
  "updatedAt": "2026-01-16T12:00:00.000Z"
}
```

---

### Get Profile by ID

Get a specific profile by ID.

**Endpoint:** `GET /profiles/by-id/:id`  
**Auth Required:** Yes

**Response:** `200 OK` (same as Get My Profile)

---

### Get Profiles by Role

Get all profiles with a specific role.

**Endpoint:** `GET /profiles/by-role/:role`  
**Auth Required:** Yes

**Parameters:**
- `role`: one of `student`, `faculty`, `super_admin`

**Response:** `200 OK`
```json
[
  {
    "id": "profile-uuid-1",
    "name": "John Doe",
    "role": "student",
    ...
  },
  {
    "id": "profile-uuid-2",
    "name": "Jane Smith",
    "role": "student",
    ...
  }
]
```

---

### Get Profiles by Department

Get all profiles in a specific department.

**Endpoint:** `GET /profiles/by-department/:department`  
**Auth Required:** Yes

**Parameters:**
- `department`: one of `IT`, `CS`, `ECS`, `ETC`, `BM`

**Response:** `200 OK` (array of profiles)

---

### Get Faculty by Department

Get all faculty members (including super admins) in a department.

**Endpoint:** `GET /profiles/faculty/:department`  
**Auth Required:** Yes

**Parameters:**
- `department`: one of `IT`, `CS`, `ECS`, `ETC`, `BM`

**Response:** `200 OK`
```json
[
  {
    "id": "faculty-uuid-1",
    "name": "Dr. Sarah Johnson",
    "role": "faculty",
    "department": "IT",
    ...
  },
  {
    "id": "faculty-uuid-2",
    "name": "IT Coordinator",
    "role": "super_admin",
    "department": "IT",
    ...
  }
]
```

---

### Get Batch Profiles

Get multiple profiles by their IDs.

**Endpoint:** `POST /profiles/batch`  
**Auth Required:** Yes

**Request Body:**
```json
{
  "ids": ["uuid-1", "uuid-2", "uuid-3"]
}
```

**Response:** `200 OK` (array of profiles)

---

## Groups

### Create Group

Create a new group. Only students can create groups.

**Endpoint:** `POST /groups/create`  
**Auth Required:** Yes  
**Role Required:** Student

**Response:** `200 OK`
```json
{
  "id": "group-uuid",
  "groupId": "IT01",
  "teamCode": "A7DXQ",
  "department": "IT",
  "createdBy": "profile-uuid",
  "isFull": false,
  "createdAt": "2026-01-16T12:00:00.000Z",
  "updatedAt": "2026-01-16T12:00:00.000Z",
  "creator": {
    "id": "profile-uuid",
    "name": "John Doe",
    ...
  },
  "members": [
    {
      "id": "member-uuid",
      "groupId": "group-uuid",
      "profileId": "profile-uuid",
      "joinedAt": "2026-01-16T12:00:00.000Z",
      "profile": {
        "id": "profile-uuid",
        "name": "John Doe",
        ...
      }
    }
  ]
}
```

**Notes:**
- Group ID is auto-generated per department (IT01, IT02, CS01, etc.)
- Team code is a random 5-character code for joining
- Creator is automatically added as first member

**Errors:**
- `400 Bad Request` - Already in a group
- `403 Forbidden` - Not a student
- `400 Bad Request` - Profile not found (complete onboarding first)

---

### Join Group

Join an existing group using team code.

**Endpoint:** `POST /groups/join`  
**Auth Required:** Yes  
**Role Required:** Student

**Request Body:**
```json
{
  "teamCode": "A7DXQ"
}
```

**Response:** `200 OK` (same structure as Create Group)

**Errors:**
- `404 Not Found` - Group not found
- `400 Bad Request` - Already in a group
- `400 Bad Request` - Group is full (max 3 members)
- `400 Bad Request` - Department mismatch
- `403 Forbidden` - Not a student

---

### Get My Group

Get the group that the current user belongs to.

**Endpoint:** `GET /groups/my-group`  
**Auth Required:** Yes

**Response:** `200 OK` (group object) or `null`

---

### Get Group by ID

Get a specific group by ID.

**Endpoint:** `GET /groups/by-id/:id`  
**Auth Required:** Yes

**Response:** `200 OK` (group object)

---

### Get Group by Team Code

Get a group by its team code.

**Endpoint:** `GET /groups/by-team-code/:teamCode`  
**Auth Required:** Yes

**Response:** `200 OK` (group object)

---

### Get Groups by Department

Get all groups in a specific department.

**Endpoint:** `GET /groups/by-department/:department`  
**Auth Required:** Yes

**Parameters:**
- `department`: one of `IT`, `CS`, `ECS`, `ETC`, `BM`

**Response:** `200 OK` (array of group objects)

---

### Get Groups with Details

Get groups with additional allocation details (for super admin dashboard).

**Endpoint:** `GET /groups/with-details/:department`  
**Auth Required:** Yes

**Parameters:**
- `department`: one of `IT`, `CS`, `ECS`, `ETC`, `BM`

**Response:** `200 OK`
```json
[
  {
    "id": "group-uuid",
    "groupId": "IT01",
    "teamCode": "A7DXQ",
    ...
    "hasSubmittedPreferences": true,
    "mentorAssigned": "Dr. Sarah Johnson"
  }
]
```

---

## Mentor Forms

### Create Mentor Allocation Form

Roll out a new mentor allocation form. Only super admins can do this.

**Endpoint:** `POST /mentor-forms`  
**Auth Required:** Yes  
**Role Required:** Super Admin

**Request Body:**
```json
{
  "availableMentorIds": [
    "faculty-uuid-1",
    "faculty-uuid-2",
    "faculty-uuid-3"
  ]
}
```

**Response:** `200 OK`
```json
{
  "id": "form-uuid",
  "department": "IT",
  "isActive": true,
  "createdBy": "admin-profile-uuid",
  "createdAt": "2026-01-16T12:00:00.000Z",
  "updatedAt": "2026-01-16T12:00:00.000Z",
  "availableMentors": [
    {
      "id": "available-mentor-uuid",
      "formId": "form-uuid",
      "mentorId": "faculty-uuid-1",
      "mentor": {
        "id": "faculty-uuid-1",
        "name": "Dr. Sarah Johnson",
        ...
      }
    }
  ]
}
```

**Notes:**
- Automatically deactivates any previously active forms for the department
- Only one active form per department at a time

**Errors:**
- `403 Forbidden` - Not a super admin
- `400 Bad Request` - No mentors selected

---

### Get Active Form

Get the currently active mentor allocation form for the user's department.

**Endpoint:** `GET /mentor-forms/active`  
**Auth Required:** Yes

**Response:** `200 OK` (form object) or `null`

---

### Get Active Form by Department

Get active form for a specific department.

**Endpoint:** `GET /mentor-forms/active/:department`  
**Auth Required:** Yes

**Parameters:**
- `department`: one of `IT`, `CS`, `ECS`, `ETC`, `BM`

**Response:** `200 OK` (form object) or `null`

---

### Get Form by ID

Get a specific form by ID.

**Endpoint:** `GET /mentor-forms/:id`  
**Auth Required:** Yes

**Response:** `200 OK` (form object)

---

### Deactivate Form

Deactivate a mentor allocation form.

**Endpoint:** `PATCH /mentor-forms/:id/deactivate`  
**Auth Required:** Yes  
**Role Required:** Super Admin

**Response:** `200 OK` (updated form object)

**Errors:**
- `403 Forbidden` - Not a super admin or different department
- `404 Not Found` - Form not found

---

## Mentor Preferences

### Submit Preferences

Submit mentor preferences for a group. Only group leaders can submit.

**Endpoint:** `POST /mentor-preferences`  
**Auth Required:** Yes  
**Role Required:** Student (Group Leader)

**Request Body:**
```json
{
  "formId": "form-uuid",
  "mentorChoices": [
    "mentor-uuid-1",
    "mentor-uuid-2",
    "mentor-uuid-3"
  ]
}
```

**Response:** `200 OK`
```json
{
  "id": "preference-uuid",
  "groupId": "group-uuid",
  "formId": "form-uuid",
  "mentorChoice1": "mentor-uuid-1",
  "mentorChoice2": "mentor-uuid-2",
  "mentorChoice3": "mentor-uuid-3",
  "submittedBy": "student-profile-uuid",
  "submittedAt": "2026-01-16T12:00:00.000Z"
}
```

**Notes:**
- Automatically creates pending allocations for each mentor choice
- Exactly 3 unique mentors must be selected
- All mentors must be from the active form's available mentors
- Only group leader can submit

**Errors:**
- `403 Forbidden` - Not the group leader
- `400 Bad Request` - Preferences already submitted
- `400 Bad Request` - Not exactly 3 choices or duplicates
- `400 Bad Request` - Invalid mentor selection
- `404 Not Found` - Form not found or inactive

---

### Get My Preferences

Get preferences for the current user's group.

**Endpoint:** `GET /mentor-preferences/my-preferences`  
**Auth Required:** Yes

**Response:** `200 OK` (preference object) or `null`

---

### Has Submitted

Check if current user's group has submitted preferences.

**Endpoint:** `GET /mentor-preferences/has-submitted`  
**Auth Required:** Yes

**Response:** `200 OK`
```json
{
  "hasSubmitted": true
}
```

---

### Get Preferences by Group

Get preferences for a specific group.

**Endpoint:** `GET /mentor-preferences/by-group/:groupId`  
**Auth Required:** Yes

**Response:** `200 OK` (preference object) or `null`

---

## Mentor Allocations

### Get Allocations for Mentor

Get all allocation requests for the current faculty member.

**Endpoint:** `GET /mentor-allocations/for-mentor`  
**Auth Required:** Yes  
**Role Required:** Faculty or Super Admin

**Response:** `200 OK`
```json
[
  {
    "id": "allocation-uuid",
    "groupId": "group-uuid",
    "mentorId": "mentor-profile-uuid",
    "formId": "form-uuid",
    "status": "pending",
    "preferenceRank": 1,
    "createdAt": "2026-01-16T12:00:00.000Z",
    "updatedAt": "2026-01-16T12:00:00.000Z",
    "group": {
      "id": "group-uuid",
      "groupId": "IT01",
      "members": [...]
    },
    "mentor": {
      "id": "mentor-uuid",
      "name": "Dr. Sarah Johnson",
      ...
    },
    "form": {
      "id": "form-uuid",
      ...
    }
  }
]
```

**Notes:**
- Results are sorted: pending first, then by preference rank
- `preferenceRank`: 1 = first choice, 2 = second choice, 3 = third choice

---

### Get Allocations for Group

Get all allocations for the current user's group.

**Endpoint:** `GET /mentor-allocations/for-group`  
**Auth Required:** Yes

**Response:** `200 OK` (array of allocation objects)

---

### Get Accepted Mentor

Get the accepted mentor for the current user's group.

**Endpoint:** `GET /mentor-allocations/accepted-mentor`  
**Auth Required:** Yes

**Response:** `200 OK`
```json
{
  "mentor": {
    "id": "mentor-uuid",
    "name": "Dr. Sarah Johnson",
    ...
  },
  "status": "accepted"
}
```

Or `null` if no mentor accepted yet.

---

### Get Mentor Status

Get allocation status for the current user's group.

**Endpoint:** `GET /mentor-allocations/status`  
**Auth Required:** Yes

**Response:** `200 OK`
```json
{
  "status": "accepted",
  "mentorName": "Dr. Sarah Johnson",
  "mentorId": "mentor-uuid"
}
```

**Possible statuses:**
- `no_group` - User not in a group
- `not_submitted` - Preferences not submitted yet
- `pending` - Waiting for mentor response
- `accepted` - Mentor accepted the team
- `all_rejected` - All mentors rejected

---

### Get Accepted Teams

Get all teams that have been accepted by the current faculty member.

**Endpoint:** `GET /mentor-allocations/accepted-teams`  
**Auth Required:** Yes  
**Role Required:** Faculty or Super Admin

**Response:** `200 OK` (array of allocations with group details)

---

### Accept Allocation

Accept a team allocation.

**Endpoint:** `POST /mentor-allocations/:id/accept`  
**Auth Required:** Yes  
**Role Required:** Faculty or Super Admin

**Response:** `200 OK`
```json
{
  "message": "Team accepted successfully"
}
```

**Notes:**
- Automatically rejects all other allocations for the same group
- Only the mentor assigned to the allocation can accept it
- Can only accept pending allocations

**Errors:**
- `403 Forbidden` - Not the assigned mentor
- `400 Bad Request` - Allocation not pending
- `404 Not Found` - Allocation not found

---

### Reject Allocation

Reject a team allocation.

**Endpoint:** `POST /mentor-allocations/:id/reject`  
**Auth Required:** Yes  
**Role Required:** Faculty or Super Admin

**Response:** `200 OK`
```json
{
  "message": "Team rejected"
}
```

**Errors:**
- `403 Forbidden` - Not the assigned mentor
- `400 Bad Request` - Allocation not pending
- `404 Not Found` - Allocation not found

---

## Error Responses

All endpoints may return the following error responses:

### 400 Bad Request
```json
{
  "statusCode": 400,
  "message": "Error description",
  "error": "Bad Request"
}
```

**Common causes:**
- Validation failed
- Business logic constraint violated
- Missing required fields

### 401 Unauthorized
```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

**Causes:**
- Missing or invalid JWT token
- Token expired

### 403 Forbidden
```json
{
  "statusCode": 403,
  "message": "Forbidden resource",
  "error": "Forbidden"
}
```

**Causes:**
- Insufficient permissions (wrong role)
- Attempting to access another department's data

### 404 Not Found
```json
{
  "statusCode": 404,
  "message": "Resource not found"
}
```

**Causes:**
- Invalid ID in URL parameter
- Resource doesn't exist

### 409 Conflict
```json
{
  "statusCode": 409,
  "message": "Resource already exists"
}
```

**Causes:**
- Duplicate email on signup
- Already in a group
- Preferences already submitted

---

## Rate Limiting

Currently no rate limiting is implemented. For production deployment, consider:
- Rate limiting per IP
- Request throttling per user
- API key requirements

---

## Versioning

Current API version: **v1**

All endpoints are prefixed with `/api`.

Future versions may use `/api/v2` etc.

---

## Support

For issues or questions:
- Check the server logs
- Use Prisma Studio (`npm run db:studio`)
- Check Supabase Table Editor
- See [API_TESTING.md](./API_TESTING.md) for testing examples

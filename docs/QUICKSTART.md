# 🚀 Quick Start Guide

## Test the Complete Flow

### 1. Create Faculty Accounts (2-3 mentors)

1. Go to http://localhost:3000
2. Click "Sign Up"
3. Create accounts:
   - Email: `mentor1@college.edu`, Password: `password123`
   - Email: `mentor2@college.edu`, Password: `password123`
   - Email: `mentor3@college.edu`, Password: `password123`
4. For each, complete onboarding:
   - Name: Dr. John Smith, Dr. Jane Doe, Dr. Bob Johnson
   - Department: **IT** (same for all)
   - Role: **Faculty (Mentor)**

### 2. Create Super Admin Account

1. Sign up with:
   - Email: `admin@college.edu`
   - Password: `password123`
2. Complete onboarding:
   - Name: Admin IT
   - Department: **IT**
   - Role: **Super Admin (Coordinator)**
   - Access Code: `ITADMIN2025`

### 3. Roll Out Mentor Allocation Form

1. Login as Super Admin
2. On dashboard, check all 3 faculty mentors **+ yourself** (Super Admin will appear with "Coordinator" badge)
3. Click "Roll Out Mentor Allocation Form"
4. ✅ Form is now active!

**Note**: Super Admins can also be mentors! You'll see your own name in the list with a "Coordinator" badge.

### 4. Create Student Accounts (3 students for one group)

**Student 1 (Leader):**
1. Sign up:
   - Email: `student1@college.edu`
   - Password: `password123`
2. Onboarding:
   - Name: Alice Johnson
   - Department: **IT**
   - Role: **Student**
   - Roll Number: 2024IT001
   - Semester: 5
3. Click "Create New Group"
4. **Note down the Team Code** (e.g., `A7DXQ`)

**Student 2 & 3 (Members):**
1. Sign up with:
   - Email: `student2@college.edu`, `student3@college.edu`
   - Password: `password123`
2. Complete onboarding (similar to above)
3. Click "Join Existing Group"
4. Enter the Team Code from Student 1
5. Click "Join Group"

### 5. Submit Mentor Preferences (as Leader)

1. Login as Student 1 (leader)
2. Click "Fill Mentor Allocation Form"
3. Select 3 mentors in order
4. Click "Submit Preferences"

### 6. Accept Team (as Faculty or Super Admin)

1. Login as one of the mentors (or as Super Admin)
2. If Super Admin: Click "View My Mentor Requests" button in top-right
3. See the team request with preference rank
4. Click "Accept Team"
5. ✅ Mentor assigned!

### 7. Verify Results

**As Student:**
- Dashboard shows "Accepted" status
- Displays assigned mentor name

**As Faculty:**
- "My Teams" section shows accepted team with green background
- "Pending Requests" section is cleared
- Stats show: 1 My Teams, 0 Pending Requests

**As Admin:**
- Groups overview shows mentor assigned
- Submission status visible

**As Super Admin (Mentor View):**
- Click "View My Mentor Requests" to see faculty dashboard
- "My Teams" shows all groups you're mentoring
- Can accept/reject other pending requests

---

## 🎨 Testing Different Departments

To test department isolation:

1. Create another Super Admin for **CS** department
   - Use access code: `CSADMIN2025`
2. Create faculty and students in **CS** department
3. Verify CS students cannot join IT groups
4. Each department has independent mentor allocation

---

## 🧪 Test Scenarios

### ✅ Positive Tests
- [ ] Student creates group and gets unique Group ID
- [ ] Student joins group with valid team code
- [ ] Group becomes full after 3 members
- [ ] Leader submits 3 mentor preferences
- [ ] Faculty accepts team request
- [ ] Admin views all department data
- [ ] Super Admin includes themselves as available mentor
- [ ] Super Admin switches to faculty view to see mentor requests
- [ ] Student sees "Coordinator" badge on Super Admin mentors

### ❌ Negative Tests
- [ ] Student tries to join group from different department
- [ ] Student tries to join full group (4th member)
- [ ] Non-leader tries to submit preferences
- [ ] Try to submit < 3 or > 3 mentors
- [ ] Wrong access code for Super Admin
- [ ] Try to submit preferences twice

---

## 💡 Tips

1. **Clear localStorage**: Open browser DevTools → Application → Local Storage → Clear All (to reset data)

2. **Multiple Users**: Use different browser profiles or incognito windows

3. **Quick Test Data**: See above credentials for rapid testing

4. **Group Codes**: Generated codes avoid confusing characters (0, O, I, 1, etc.)

5. **Department Codes**: IT, CS, ECS, ETC, BM

---

## 🐛 Common Issues

**Issue**: "Group not found"
- Solution: Ensure Team Code is correct (case-sensitive, 5 characters)

**Issue**: "Cannot join group - different department"
- Solution: Only students from same department can join

**Issue**: "Invalid coordinator access code"
- Solution: Check department and use correct code from README

**Issue**: "Preferences already submitted"
- Solution: Each group can only submit once (by design)

---

Happy Testing! 🎉


-- =====================================================
-- PROJECT HUB - SEED FOR MENTOR ALLOCATION TESTING
-- =====================================================
-- This seed sets up the system for testing from MENTOR ALLOCATION FORM ROLLOUT
-- 
-- What's included:
-- ✅ 12 Students (4 teams of 3)
-- ✅ 3 Faculty members
-- ✅ 1 Super Admin
-- ✅ 4 Groups/Teams formed (IT01, IT02, IT03, IT04)
-- ✅ All group memberships
--
-- What's NOT included (for testing):
-- ❌ Mentor Allocation Form (Super Admin will roll out)
-- ❌ Mentor Preferences (Students will submit after form rollout)
-- ❌ Mentor Allocations (Faculty will accept/reject)
-- ❌ Topics, Reviews (will come after mentor allocation)
--
-- Password for all users: password123
-- =====================================================

-- Clear existing data (in reverse order of dependencies)
DELETE FROM "ReviewMessage";
DELETE FROM "ReviewSession";
DELETE FROM "ReviewRollout";
DELETE FROM "TopicMessage";
DELETE FROM "ProjectTopic";
DELETE FROM "MentorAllocation";
DELETE FROM "MentorPreference";
DELETE FROM "AvailableMentor";
DELETE FROM "MentorAllocationForm";
DELETE FROM "GroupMember";
DELETE FROM "Group";
DELETE FROM "GroupCounter";
DELETE FROM "Profile";
DELETE FROM "User";

-- =====================================================
-- USERS (password hash is for 'password123')
-- =====================================================

-- Students (12 students for 4 groups of 3)
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES 
  ('user-student-1', 'student1@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-2', 'student2@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-3', 'student3@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-4', 'student4@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-5', 'student5@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-6', 'student6@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-7', 'student7@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-8', 'student8@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-9', 'student9@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-10', 'student10@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-11', 'student11@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-12', 'student12@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Faculty Members (3 faculty)
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES 
  ('user-faculty-1', 'faculty1@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-faculty-2', 'faculty2@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-faculty-3', 'faculty3@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Super Admin
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES 
  ('user-superadmin', 'superadmin@gmail.com', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- =====================================================
-- PROFILES
-- =====================================================

-- Student Profiles
INSERT INTO "Profile" (id, "userId", name, email, role, department, "rollNumber", semester, "createdAt", "updatedAt")
VALUES 
  ('profile-student-1', 'user-student-1', 'Arkan Khan', 'student1@gmail.com', 'student', 'IT', '22101A0001', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-2', 'user-student-2', 'Anuj Gill', 'student2@gmail.com', 'student', 'IT', '22101A0002', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-3', 'user-student-3', 'Sahil Shangloo', 'student3@gmail.com', 'student', 'IT', '22101A0003', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-4', 'user-student-4', 'Om Alve', 'student4@gmail.com', 'student', 'IT', '22101A0004', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-5', 'user-student-5', 'Rutuja Bangera', 'student5@gmail.com', 'student', 'IT', '22101A0005', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-6', 'user-student-6', 'Sonal Solaskar', 'student6@gmail.com', 'student', 'IT', '22101A0006', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-7', 'user-student-7', 'Pratik Sawant', 'student7@gmail.com', 'student', 'IT', '22101A0007', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-8', 'user-student-8', 'Sankalp Wani', 'student8@gmail.com', 'student', 'IT', '22101A0008', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-9', 'user-student-9', 'Abhishek Pal', 'student9@gmail.com', 'student', 'IT', '22101A0009', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-10', 'user-student-10', 'Jack Mehta', 'student10@gmail.com', 'student', 'IT', '22101A0010', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-11', 'user-student-11', 'Kate Rao', 'student11@gmail.com', 'student', 'IT', '22101A0011', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-12', 'user-student-12', 'Leo Iyer', 'student12@gmail.com', 'student', 'IT', '22101A0012', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Faculty Profiles
INSERT INTO "Profile" (id, "userId", name, email, role, department, "createdAt", "updatedAt")
VALUES 
  ('profile-faculty-1', 'user-faculty-1', 'Prof. Rasika Ransing', 'faculty1@gmail.com', 'faculty', 'IT', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-faculty-2', 'user-faculty-2', 'Prof. Neha Kudu', 'faculty2@gmail.com', 'faculty', 'IT', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-faculty-3', 'user-faculty-3', 'Prof. Vinita Bhandiwad', 'faculty3@gmail.com', 'faculty', 'IT', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Super Admin Profile
INSERT INTO "Profile" (id, "userId", name, email, role, department, "createdAt", "updatedAt")
VALUES 
  ('profile-superadmin', 'user-superadmin', 'Prof. Kanchan Dhuri', 'superadmin@gmail.com', 'super_admin', 'IT', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- =====================================================
-- GROUP COUNTER
-- =====================================================

INSERT INTO "GroupCounter" (id, department, counter)
VALUES 
  ('counter-IT', 'IT', 4);

-- =====================================================
-- GROUPS (4 teams already formed)
-- =====================================================

INSERT INTO "Group" (id, "groupId", "teamCode", department, "createdBy", "isFull", "createdAt", "updatedAt")
VALUES 
  ('group-1', 'IT01', 'TEAM1', 'IT', 'profile-student-1', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('group-2', 'IT02', 'TEAM2', 'IT', 'profile-student-4', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('group-3', 'IT03', 'TEAM3', 'IT', 'profile-student-7', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('group-4', 'IT04', 'TEAM4', 'IT', 'profile-student-10', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- =====================================================
-- GROUP MEMBERS
-- =====================================================

-- Group 1 (IT01): Arkan, Anuj, Sahil
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-1-1', 'group-1', 'profile-student-1', '2025-10-29 10:00:00'),
  ('member-1-2', 'group-1', 'profile-student-2', '2025-10-29 10:00:00'),
  ('member-1-3', 'group-1', 'profile-student-3', '2025-10-29 10:00:00');

-- Group 2 (IT02): Om, Rutuja, Sonal
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-2-1', 'group-2', 'profile-student-4', '2025-10-29 10:00:00'),
  ('member-2-2', 'group-2', 'profile-student-5', '2025-10-29 10:00:00'),
  ('member-2-3', 'group-2', 'profile-student-6', '2025-10-29 10:00:00');

-- Group 3 (IT03): Pratik, Sankalp, Abhishek
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-3-1', 'group-3', 'profile-student-7', '2025-10-29 10:00:00'),
  ('member-3-2', 'group-3', 'profile-student-8', '2025-10-29 10:00:00'),
  ('member-3-3', 'group-3', 'profile-student-9', '2025-10-29 10:00:00');

-- Group 4 (IT04): Jack, Kate, Leo
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-4-1', 'group-4', 'profile-student-10', '2025-10-29 10:00:00'),
  ('member-4-2', 'group-4', 'profile-student-11', '2025-10-29 10:00:00'),
  ('member-4-3', 'group-4', 'profile-student-12', '2025-10-29 10:00:00');

-- =====================================================
-- TESTING WORKFLOW
-- =====================================================
-- 
-- 1. Login as Super Admin: superadmin@gmail.com / password123
-- 2. Roll out Mentor Allocation Form (select faculty members)
-- 3. Login as Student (team leader): student1@gmail.com / password123
-- 4. Submit mentor preferences (3 choices)
-- 5. Login as Faculty: faculty1@gmail.com / password123
-- 6. Accept/Reject team requests
-- 7. Continue to Topic Approval and Reviews...
--
-- =====================================================

-- =====================================================
-- TEST ACCOUNTS REFERENCE
-- =====================================================
-- 
-- SUPER ADMIN:
--   Email: superadmin@gmail.com
--   Password: password123
--
-- FACULTY:
--   faculty1@gmail.com / password123 - Prof. Rasika Ransing
--   faculty2@gmail.com / password123 - Prof. Neha Kudu
--   faculty3@gmail.com / password123 - Prof. Vinita Bhandiwad
--
-- STUDENTS (Team Leaders marked with *):
--   IT01: student1@gmail.com* (Arkan), student2@gmail.com (Anuj), student3@gmail.com (Sahil)
--   IT02: student4@gmail.com* (Om), student5@gmail.com (Rutuja), student6@gmail.com (Sonal)
--   IT03: student7@gmail.com* (Pratik), student8@gmail.com (Sankalp), student9@gmail.com (Abhishek)
--   IT04: student10@gmail.com* (Jack), student11@gmail.com (Kate), student12@gmail.com (Leo)
--
-- =====================================================

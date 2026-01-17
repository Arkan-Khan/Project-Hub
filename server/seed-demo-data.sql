-- =====================================================
-- PROJECT HUB - DEMO SEED DATA
-- =====================================================
-- This file contains SQL queries to seed the database with demo data
-- Aligned with frontend types and static.md test data structure
-- 4 teams of 3 students each, 3 faculty, 1 super admin
-- All teams have accepted mentors so topic approval is visible
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
-- USERS (password hash is for 'password')
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
  ('profile-student-1', 'user-student-1', 'Alice Kumar', 'student1@gmail.com', 'student', 'IT', '22101A0001', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-2', 'user-student-2', 'Bob Sharma', 'student2@gmail.com', 'student', 'IT', '22101A0002', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-3', 'user-student-3', 'Charlie Singh', 'student3@gmail.com', 'student', 'IT', '22101A0003', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-4', 'user-student-4', 'Diana Patel', 'student4@gmail.com', 'student', 'IT', '22101A0004', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-5', 'user-student-5', 'Eve Gupta', 'student5@gmail.com', 'student', 'IT', '22101A0005', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-6', 'user-student-6', 'Frank Verma', 'student6@gmail.com', 'student', 'IT', '22101A0006', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-7', 'user-student-7', 'Grace Joshi', 'student7@gmail.com', 'student', 'IT', '22101A0007', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-8', 'user-student-8', 'Henry Reddy', 'student8@gmail.com', 'student', 'IT', '22101A0008', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-9', 'user-student-9', 'Ivy Nair', 'student9@gmail.com', 'student', 'IT', '22101A0009', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-10', 'user-student-10', 'Jack Mehta', 'student10@gmail.com', 'student', 'IT', '22101A0010', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-11', 'user-student-11', 'Kate Rao', 'student11@gmail.com', 'student', 'IT', '22101A0011', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-12', 'user-student-12', 'Leo Iyer', 'student12@gmail.com', 'student', 'IT', '22101A0012', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Faculty Profiles
INSERT INTO "Profile" (id, "userId", name, email, role, department, "createdAt", "updatedAt")
VALUES 
  ('profile-faculty-1', 'user-faculty-1', 'Dr. Ramesh Kumar', 'faculty1@gmail.com', 'faculty', 'IT', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-faculty-2', 'user-faculty-2', 'Dr. Priya Sharma', 'faculty2@gmail.com', 'faculty', 'IT', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-faculty-3', 'user-faculty-3', 'Dr. Amit Patel', 'faculty3@gmail.com', 'faculty', 'IT', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Super Admin Profile
INSERT INTO "Profile" (id, "userId", name, email, role, department, "createdAt", "updatedAt")
VALUES 
  ('profile-superadmin', 'user-superadmin', 'Prof. Suresh Coordinator', 'superadmin@gmail.com', 'super_admin', 'IT', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- =====================================================
-- GROUP COUNTER
-- =====================================================

INSERT INTO "GroupCounter" (id, department, counter)
VALUES 
  ('counter-IT', 'IT', 4);

-- =====================================================
-- GROUPS
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

-- Group 1 members
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-1-1', 'group-1', 'profile-student-1', '2025-10-29 10:00:00'),
  ('member-1-2', 'group-1', 'profile-student-2', '2025-10-29 10:00:00'),
  ('member-1-3', 'group-1', 'profile-student-3', '2025-10-29 10:00:00');

-- Group 2 members
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-2-1', 'group-2', 'profile-student-4', '2025-10-29 10:00:00'),
  ('member-2-2', 'group-2', 'profile-student-5', '2025-10-29 10:00:00'),
  ('member-2-3', 'group-2', 'profile-student-6', '2025-10-29 10:00:00');

-- Group 3 members
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-3-1', 'group-3', 'profile-student-7', '2025-10-29 10:00:00'),
  ('member-3-2', 'group-3', 'profile-student-8', '2025-10-29 10:00:00'),
  ('member-3-3', 'group-3', 'profile-student-9', '2025-10-29 10:00:00');

-- Group 4 members
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-4-1', 'group-4', 'profile-student-10', '2025-10-29 10:00:00'),
  ('member-4-2', 'group-4', 'profile-student-11', '2025-10-29 10:00:00'),
  ('member-4-3', 'group-4', 'profile-student-12', '2025-10-29 10:00:00');

-- =====================================================
-- MENTOR ALLOCATION FORM
-- =====================================================

INSERT INTO "MentorAllocationForm" (id, department, "isActive", "createdBy", "createdAt", "updatedAt")
VALUES 
  ('form-1', 'IT', true, 'profile-superadmin', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- =====================================================
-- AVAILABLE MENTORS FOR THE FORM
-- =====================================================

INSERT INTO "AvailableMentor" (id, "formId", "mentorId")
VALUES 
  ('avail-1', 'form-1', 'profile-faculty-1'),
  ('avail-2', 'form-1', 'profile-faculty-2'),
  ('avail-3', 'form-1', 'profile-faculty-3'),
  ('avail-4', 'form-1', 'profile-superadmin');

-- =====================================================
-- MENTOR PREFERENCES
-- =====================================================

INSERT INTO "MentorPreference" (id, "groupId", "formId", "mentorChoice1", "mentorChoice2", "mentorChoice3", "submittedBy", "submittedAt")
VALUES 
  ('pref-1', 'group-1', 'form-1', 'profile-faculty-1', 'profile-faculty-2', 'profile-faculty-3', 'profile-student-1', '2025-10-29 11:00:00'),
  ('pref-2', 'group-2', 'form-1', 'profile-faculty-2', 'profile-faculty-3', 'profile-faculty-1', 'profile-student-4', '2025-10-29 11:00:00'),
  ('pref-3', 'group-3', 'form-1', 'profile-faculty-3', 'profile-faculty-1', 'profile-faculty-2', 'profile-student-7', '2025-10-29 11:00:00'),
  ('pref-4', 'group-4', 'form-1', 'profile-superadmin', 'profile-faculty-1', 'profile-faculty-2', 'profile-student-10', '2025-10-29 11:00:00');

-- =====================================================
-- MENTOR ALLOCATIONS (All Accepted - Required for Topic Approval)
-- =====================================================

INSERT INTO "MentorAllocation" (id, "groupId", "mentorId", "formId", status, "preferenceRank", "createdAt", "updatedAt")
VALUES 
  ('alloc-1', 'group-1', 'profile-faculty-1', 'form-1', 'accepted', 1, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-2', 'group-2', 'profile-faculty-2', 'form-1', 'accepted', 1, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-3', 'group-3', 'profile-faculty-3', 'form-1', 'accepted', 1, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-4', 'group-4', 'profile-superadmin', 'form-1', 'accepted', 1, '2025-10-29 11:00:00', '2025-10-29 12:00:00');

-- =====================================================
-- PROJECT TOPICS (Empty - Ready for testing topic submission)
-- =====================================================
-- No topics inserted - students can submit topics for approval testing

-- =====================================================
-- TOPIC MESSAGES (Empty)
-- =====================================================
-- No messages inserted

-- =====================================================
-- REVIEW ROLLOUTS (Empty)
-- =====================================================
-- No rollouts inserted

-- =====================================================
-- REVIEW SESSIONS (Empty)
-- =====================================================
-- No sessions inserted

-- =====================================================
-- REVIEW MESSAGES (Empty)
-- =====================================================
-- No messages inserted

-- =====================================================
-- SEED DATA SUMMARY
-- =====================================================
-- Users: 1 Super Admin, 3 Faculty, 12 Students (password: 'password')
-- Groups: 4 groups of 3 students each
-- Mentor Allocations: All 4 groups have ACCEPTED mentors
--   - IT01 (TEAM1) → Dr. Ramesh Kumar (Faculty 1)
--   - IT02 (TEAM2) → Dr. Priya Sharma (Faculty 2)
--   - IT03 (TEAM3) → Dr. Amit Patel (Faculty 3)
--   - IT04 (TEAM4) → Prof. Suresh Coordinator (Super Admin)
-- Project Topics: Empty (ready for topic approval testing)
-- Review Data: Empty (ready for review testing)
--
-- LOGIN CREDENTIALS (all passwords: 'password'):
--   Students: student1@gmail.com to student12@gmail.com
--   Faculty: faculty1@gmail.com, faculty2@gmail.com, faculty3@gmail.com
--   Super Admin: superadmin@gmail.com
-- =====================================================

-- Verify data
SELECT 'Users' as entity, COUNT(*) as count FROM "User"
UNION ALL
SELECT 'Profiles', COUNT(*) FROM "Profile"
UNION ALL
SELECT 'Groups', COUNT(*) FROM "Group"
UNION ALL
SELECT 'Group Members', COUNT(*) FROM "GroupMember"
UNION ALL
SELECT 'Mentor Forms', COUNT(*) FROM "MentorAllocationForm"
UNION ALL
SELECT 'Available Mentors', COUNT(*) FROM "AvailableMentor"
UNION ALL
SELECT 'Mentor Preferences', COUNT(*) FROM "MentorPreference"
UNION ALL
SELECT 'Mentor Allocations', COUNT(*) FROM "MentorAllocation"
UNION ALL
SELECT 'Project Topics', COUNT(*) FROM "ProjectTopic"
UNION ALL
SELECT 'Topic Messages', COUNT(*) FROM "TopicMessage"
UNION ALL
SELECT 'Review Rollouts', COUNT(*) FROM "ReviewRollout"
UNION ALL
SELECT 'Review Sessions', COUNT(*) FROM "ReviewSession"
UNION ALL
SELECT 'Review Messages', COUNT(*) FROM "ReviewMessage";

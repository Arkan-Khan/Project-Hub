-- =====================================================
-- PROJECT HUB - DEMO SEED DATA
-- =====================================================
-- Scope:
-- - 4 IT faculty + 1 IT super admin
-- - 4 student groups
-- - Semester distribution: 2 groups same semester, 2 groups different semesters
-- - No mentors assigned yet (superadmin must roll out mentor form in app)
-- - Password hash used for all users:
--   $2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi
-- =====================================================

-- Clear existing data (in reverse dependency order)
DELETE FROM "StudentGrade";
DELETE FROM "ReviewEvaluation";
DELETE FROM "TopicApprovalDocument";
DELETE FROM "Attachment";
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
-- USERS
-- =====================================================

-- Students (12 students for 4 groups of 3)
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES
  ('user-student-1', 'student1@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-2', 'student2@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-3', 'student3@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-4', 'student4@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-5', 'student5@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-6', 'student6@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-7', 'student7@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-8', 'student8@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-9', 'student9@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-10', 'student10@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-11', 'student11@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-12', 'student12@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Faculty Members (4 faculty)
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES
  ('user-faculty-1', 'faculty1@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-faculty-2', 'faculty2@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-faculty-3', 'faculty3@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-faculty-4', 'faculty4@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Super Admin (IT)
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES
  ('user-superadmin', 'superadmin@gmail.com', '$2b$10$O8vQTXOTS0PXmNEQkTc2pOxZM0g9pYpm2X0KrSdODYOhSwxu9WdUi', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- =====================================================
-- PROFILES
-- =====================================================

-- Student profiles
-- Semester distribution by group:
-- - IT01: Semester 7
-- - IT02: Semester 7
-- - IT03: Semester 5
-- - IT04: Semester 6
INSERT INTO "Profile" (id, "userId", name, email, role, department, "rollNumber", semester, "createdAt", "updatedAt")
VALUES
  ('profile-student-1', 'user-student-1', 'Arkan Khan', 'student1@gmail.com', 'student', 'IT', '22101A0001', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-2', 'user-student-2', 'Anuj Gill', 'student2@gmail.com', 'student', 'IT', '22101A0002', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-3', 'user-student-3', 'Sahil Shangloo', 'student3@gmail.com', 'student', 'IT', '22101A0003', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-4', 'user-student-4', 'Om Alve', 'student4@gmail.com', 'student', 'IT', '22101A0004', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-5', 'user-student-5', 'Rutuja Bangera', 'student5@gmail.com', 'student', 'IT', '22101A0005', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-6', 'user-student-6', 'Sonal Solaskar', 'student6@gmail.com', 'student', 'IT', '22101A0006', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-7', 'user-student-7', 'Pratik Sawant', 'student7@gmail.com', 'student', 'IT', '22101A0007', 5, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-8', 'user-student-8', 'Sankalp Wani', 'student8@gmail.com', 'student', 'IT', '22101A0008', 5, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-9', 'user-student-9', 'Abhishek Pal', 'student9@gmail.com', 'student', 'IT', '22101A0009', 5, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-10', 'user-student-10', 'Parth Kale', 'student10@gmail.com', 'student', 'IT', '22101A0010', 6, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-11', 'user-student-11', 'Arpit Gaikwad', 'student11@gmail.com', 'student', 'IT', '22101A0011', 6, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-12', 'user-student-12', 'Jayant Dethe', 'student12@gmail.com', 'student', 'IT', '22101A0012', 6, '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Faculty profiles (same base faculty names retained; added faculty 4)
INSERT INTO "Profile" (id, "userId", name, email, role, department, domains, "createdAt", "updatedAt")
VALUES
  ('profile-faculty-1', 'user-faculty-1', 'Prof. Rasika Ransing', 'faculty1@gmail.com', 'faculty', 'IT', 'AI, Machine Learning, Data Science', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-faculty-2', 'user-faculty-2', 'Prof. Neha Kudu', 'faculty2@gmail.com', 'faculty', 'IT', 'Web Development, Cloud Computing', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-faculty-3', 'user-faculty-3', 'Prof. Vinita Bhandiwad', 'faculty3@gmail.com', 'faculty', 'IT', 'Cyber Security, IoT, Blockchain', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-faculty-4', 'user-faculty-4', 'Prof. Akshay Loke', 'faculty4@gmail.com', 'faculty', 'IT', 'Software Engineering, DevOps', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Super admin profile (IT)
INSERT INTO "Profile" (id, "userId", name, email, role, department, domains, "createdAt", "updatedAt")
VALUES
  ('profile-superadmin', 'user-superadmin', 'Prof. Kanchan Dhuri', 'superadmin@gmail.com', 'super_admin', 'IT', 'Software Engineering, DevOps', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- =====================================================
-- GROUP COUNTER + GROUPS
-- =====================================================

INSERT INTO "GroupCounter" (id, department, counter)
VALUES
  ('counter-IT', 'IT', 4);

INSERT INTO "Group" (id, "groupId", "teamCode", department, "createdBy", "isFull", "createdAt", "updatedAt")
VALUES
  ('group-1', 'IT01', 'TEAM1', 'IT', 'profile-student-1', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('group-2', 'IT02', 'TEAM2', 'IT', 'profile-student-4', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('group-3', 'IT03', 'TEAM3', 'IT', 'profile-student-7', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('group-4', 'IT04', 'TEAM4', 'IT', 'profile-student-10', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Group members
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES
  ('member-1-1', 'group-1', 'profile-student-1', '2025-10-29 10:00:00'),
  ('member-1-2', 'group-1', 'profile-student-2', '2025-10-29 10:00:00'),
  ('member-1-3', 'group-1', 'profile-student-3', '2025-10-29 10:00:00'),
  ('member-2-1', 'group-2', 'profile-student-4', '2025-10-29 10:00:00'),
  ('member-2-2', 'group-2', 'profile-student-5', '2025-10-29 10:00:00'),
  ('member-2-3', 'group-2', 'profile-student-6', '2025-10-29 10:00:00'),
  ('member-3-1', 'group-3', 'profile-student-7', '2025-10-29 10:00:00'),
  ('member-3-2', 'group-3', 'profile-student-8', '2025-10-29 10:00:00'),
  ('member-3-3', 'group-3', 'profile-student-9', '2025-10-29 10:00:00'),
  ('member-4-1', 'group-4', 'profile-student-10', '2025-10-29 10:00:00'),
  ('member-4-2', 'group-4', 'profile-student-11', '2025-10-29 10:00:00'),
  ('member-4-3', 'group-4', 'profile-student-12', '2025-10-29 10:00:00');

-- =====================================================
-- MENTOR SETUP (rollout starts from superadmin)
-- =====================================================

-- Intentionally no inserts into:
-- - MentorAllocationForm
-- - AvailableMentor
-- - MentorPreference
-- - MentorAllocation
-- This keeps all groups unassigned so superadmin can roll out the form manually.

-- =====================================================
-- QUICK VERIFICATION
-- =====================================================

SELECT 'Users' AS entity, COUNT(*) AS count FROM "User"
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
SELECT 'Mentor Allocations', COUNT(*) FROM "MentorAllocation";

-- Login emails:
-- Super Admin: superadmin@gmail.com
-- Faculty: faculty1@gmail.com, faculty2@gmail.com, faculty3@gmail.com, faculty4@gmail.com
-- Students: student1@gmail.com ... student12@gmail.com

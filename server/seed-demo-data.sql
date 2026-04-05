-- =====================================================
-- PROJECT HUB - DEMO SEED DATA
-- =====================================================
-- This file contains SQL queries to seed the database with demo data
-- Aligned with frontend types and static.md test data structure
-- 4 teams of 3 students each, 3 faculty, 1 super admin
-- All teams have accepted mentors so topic approval is visible
-- =====================================================

-- Clear existing data (in reverse order of dependencies)
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
-- USERS (password hash is for 'password')
-- =====================================================

-- Students (12 students for 4 groups of 3)
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES 
  ('user-student-1', 'student1@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-2', 'student2@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-3', 'student3@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-4', 'student4@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-5', 'student5@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-6', 'student6@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-7', 'student7@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-8', 'student8@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-9', 'student9@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-10', 'student10@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-11', 'student11@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-12', 'student12@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Faculty Members (3 faculty)
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES 
  ('user-faculty-1', 'faculty1@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-faculty-2', 'faculty2@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-faculty-3', 'faculty3@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Super Admin
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES 
  ('user-superadmin', 'superadmin@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

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

-- Faculty Profiles (with domains)
INSERT INTO "Profile" (id, "userId", name, email, role, department, domains, "createdAt", "updatedAt")
VALUES
  ('profile-faculty-1', 'user-faculty-1', 'Prof. Rasika Ransing', 'faculty1@gmail.com', 'faculty', 'IT', 'AI, Machine Learning, Data Science', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-faculty-2', 'user-faculty-2', 'Prof. Neha Kudu', 'faculty2@gmail.com', 'faculty', 'IT', 'Web Development, Cloud Computing', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-faculty-3', 'user-faculty-3', 'Prof. Vinita Bhandiwad', 'faculty3@gmail.com', 'faculty', 'IT', 'Cyber Security, IoT, Blockchain', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Super Admin Profile (with domains)
INSERT INTO "Profile" (id, "userId", name, email, role, department, domains, "createdAt", "updatedAt")
VALUES
  ('profile-superadmin', 'user-superadmin', 'Prof. Kanchan Dhuri', 'superadmin@gmail.com', 'super_admin', 'IT', 'Software Engineering, DevOps', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

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
-- MENTOR ALLOCATIONS (Sequential Routing - 1st choice accepted, 2nd/3rd rejected)
-- =====================================================

-- Group 1: 1st choice accepted, 2nd and 3rd auto-rejected
INSERT INTO "MentorAllocation" (id, "groupId", "mentorId", "formId", status, "preferenceRank", "createdAt", "updatedAt")
VALUES
  ('alloc-1-1', 'group-1', 'profile-faculty-1', 'form-1', 'accepted', 1, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-1-2', 'group-1', 'profile-faculty-2', 'form-1', 'rejected', 2, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-1-3', 'group-1', 'profile-faculty-3', 'form-1', 'rejected', 3, '2025-10-29 11:00:00', '2025-10-29 12:00:00');

-- Group 2: 1st choice accepted, 2nd and 3rd auto-rejected
INSERT INTO "MentorAllocation" (id, "groupId", "mentorId", "formId", status, "preferenceRank", "createdAt", "updatedAt")
VALUES
  ('alloc-2-1', 'group-2', 'profile-faculty-2', 'form-1', 'accepted', 1, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-2-2', 'group-2', 'profile-faculty-3', 'form-1', 'rejected', 2, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-2-3', 'group-2', 'profile-faculty-1', 'form-1', 'rejected', 3, '2025-10-29 11:00:00', '2025-10-29 12:00:00');

-- Group 3: 1st choice accepted, 2nd and 3rd auto-rejected
INSERT INTO "MentorAllocation" (id, "groupId", "mentorId", "formId", status, "preferenceRank", "createdAt", "updatedAt")
VALUES
  ('alloc-3-1', 'group-3', 'profile-faculty-3', 'form-1', 'accepted', 1, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-3-2', 'group-3', 'profile-faculty-1', 'form-1', 'rejected', 2, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-3-3', 'group-3', 'profile-faculty-2', 'form-1', 'rejected', 3, '2025-10-29 11:00:00', '2025-10-29 12:00:00');

-- Group 4: 1st choice accepted, 2nd and 3rd auto-rejected
INSERT INTO "MentorAllocation" (id, "groupId", "mentorId", "formId", status, "preferenceRank", "createdAt", "updatedAt")
VALUES
  ('alloc-4-1', 'group-4', 'profile-superadmin', 'form-1', 'accepted', 1, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-4-2', 'group-4', 'profile-faculty-1', 'form-1', 'rejected', 2, '2025-10-29 11:00:00', '2025-10-29 12:00:00'),
  ('alloc-4-3', 'group-4', 'profile-faculty-2', 'form-1', 'rejected', 3, '2025-10-29 11:00:00', '2025-10-29 12:00:00');

-- =====================================================
-- PROJECT TOPICS (Some groups have approved topics)
-- =====================================================

-- Group 1: Approved topic
INSERT INTO "ProjectTopic" (id, "groupId", title, description, status, "submittedBy", "reviewedBy", "submittedAt", "reviewedAt", "updatedAt")
VALUES
  ('topic-1', 'group-1', 'AI-Powered Student Attendance System', 'An automated attendance tracking system using facial recognition and machine learning to mark student attendance in classrooms. Features include real-time face detection, attendance reports, and integration with college ERP.', 'approved', 'profile-student-1', 'profile-faculty-1', '2025-10-30 10:00:00', '2025-10-31 14:00:00', '2025-10-31 14:00:00');

-- Group 2: Approved topic
INSERT INTO "ProjectTopic" (id, "groupId", title, description, status, "submittedBy", "reviewedBy", "submittedAt", "reviewedAt", "updatedAt")
VALUES
  ('topic-2', 'group-2', 'Cloud-Based Project Management Platform', 'A comprehensive project management tool built on cloud infrastructure supporting team collaboration, task tracking, Gantt charts, and real-time notifications. Integrates with popular services like GitHub and Slack.', 'approved', 'profile-student-4', 'profile-faculty-2', '2025-10-30 11:00:00', '2025-10-31 15:00:00', '2025-10-31 15:00:00');

-- Group 3: Submitted topic (waiting for mentor review)
INSERT INTO "ProjectTopic" (id, "groupId", title, description, status, "submittedBy", "submittedAt", "updatedAt")
VALUES
  ('topic-3', 'group-3', 'Blockchain-Based Certificate Verification', 'A decentralized application for issuing and verifying academic certificates using blockchain technology to prevent forgery and ensure authenticity.', 'submitted', 'profile-student-7', '2025-10-30 12:00:00', '2025-10-30 12:00:00');

-- Group 4: No topic submitted yet (for testing topic submission flow)
-- Topic will be submitted by students during testing

-- =====================================================
-- TOPIC MESSAGES (Conversation threads for topics)
-- =====================================================

-- Messages for Group 1's topic
INSERT INTO "TopicMessage" (id, "topicId", "groupId", "authorId", "authorName", "authorRole", content, links, "createdAt")
VALUES
  ('tmsg-1-1', 'topic-1', 'group-1', 'profile-student-1', 'Arkan Khan', 'student', 'We have submitted our project topic on AI-based attendance system. Looking forward to your feedback.', '{}', '2025-10-30 10:05:00'),
  ('tmsg-1-2', 'topic-1', 'group-1', 'profile-faculty-1', 'Prof. Rasika Ransing', 'faculty', 'Interesting topic! Can you elaborate on the ML model you plan to use for face recognition?', '{}', '2025-10-30 14:00:00'),
  ('tmsg-1-3', 'topic-1', 'group-1', 'profile-student-1', 'Arkan Khan', 'student', 'We are planning to use MTCNN for face detection and FaceNet embeddings for recognition. We will train on a custom dataset of student faces.', '{}', '2025-10-30 15:30:00'),
  ('tmsg-1-4', 'topic-1', 'group-1', 'profile-faculty-1', 'Prof. Rasika Ransing', 'faculty', 'Great approach! I am approving this topic. Make sure to address privacy concerns in your implementation.', '{}', '2025-10-31 14:00:00');

-- Messages for Group 2's topic  
INSERT INTO "TopicMessage" (id, "topicId", "groupId", "authorId", "authorName", "authorRole", content, links, "createdAt")
VALUES
  ('tmsg-2-1', 'topic-2', 'group-2', 'profile-student-4', 'Om Alve', 'student', 'Submitting our project proposal for a cloud-based project management platform.', '{}', '2025-10-30 11:05:00'),
  ('tmsg-2-2', 'topic-2', 'group-2', 'profile-faculty-2', 'Prof. Neha Kudu', 'faculty', 'Nice! What cloud provider are you targeting? And will you support real-time collaboration?', '{}', '2025-10-30 16:00:00'),
  ('tmsg-2-3', 'topic-2', 'group-2', 'profile-student-4', 'Om Alve', 'student', 'We plan to use AWS (EC2, RDS, S3) and implement real-time features using WebSockets.', '{}', '2025-10-30 17:00:00'),
  ('tmsg-2-4', 'topic-2', 'group-2', 'profile-faculty-2', 'Prof. Neha Kudu', 'faculty', 'Approved! Focus on scalability in your architecture design.', '{}', '2025-10-31 15:00:00');

-- Messages for Group 3's topic (still pending)
INSERT INTO "TopicMessage" (id, "topicId", "groupId", "authorId", "authorName", "authorRole", content, links, "createdAt")
VALUES
  ('tmsg-3-1', 'topic-3', 'group-3', 'profile-student-7', 'Pratik Sawant', 'student', 'We want to work on blockchain-based certificate verification to help prevent fake degrees.', '{}', '2025-10-30 12:05:00'),
  ('tmsg-3-2', 'topic-3', 'group-3', 'profile-faculty-3', 'Prof. Vinita Bhandiwad', 'faculty', 'Interesting concept! Which blockchain platform do you plan to use - Ethereum, Hyperledger, or something else?', '{}', '2025-10-30 18:00:00');

-- =====================================================
-- REVIEW ROLLOUTS (Admin has rolled out Review 1)
-- =====================================================

INSERT INTO "ReviewRollout" (id, department, "reviewType", "isActive", "createdBy", "createdAt", "updatedAt")
VALUES
  ('rollout-review1', 'IT', 'review_1', true, 'profile-superadmin', '2025-11-01 10:00:00', '2025-11-01 10:00:00');

-- =====================================================
-- REVIEW SESSIONS (Groups with approved topics have Review 1 sessions)
-- =====================================================

-- Group 1: Review 1 completed
INSERT INTO "ReviewSession" (id, "groupId", "reviewType", status, "progressPercentage", "progressDescription", "submittedBy", "submittedAt", "mentorFeedback", "feedbackGivenBy", "feedbackGivenAt", "createdAt", "updatedAt")
VALUES
  ('session-1-r1', 'group-1', 'review_1', 'completed', 85, 'Face detection module completed with 92% accuracy. Architecture diagram finalized. Integration with college ERP in progress.', 'profile-student-1', '2025-11-05 10:00:00', 'Good progress! The detection accuracy looks promising. Work on improving the lighting conditions handling before Review 2. Score: 85/100', 'profile-faculty-1', '2025-11-05 11:00:00', '2025-11-05 10:00:00', '2025-11-05 11:00:00');

-- Group 2: Review 1 in progress
INSERT INTO "ReviewSession" (id, "groupId", "reviewType", status, "progressPercentage", "progressDescription", "submittedBy", "submittedAt", "createdAt", "updatedAt")
VALUES
  ('session-2-r1', 'group-2', 'review_1', 'in_progress', 60, 'Backend APIs 60% complete. AWS infrastructure set up. Frontend dashboard wireframes ready.', 'profile-student-4', '2025-11-06 14:00:00', '2025-11-06 14:00:00', '2025-11-06 14:30:00');

-- =====================================================
-- REVIEW MESSAGES (Feedback during reviews)
-- =====================================================

-- Group 1 Review 1 messages
INSERT INTO "ReviewMessage" (id, "sessionId", "groupId", "authorId", "authorName", "authorRole", content, links, "createdAt")
VALUES
  ('rmsg-1-1', 'session-1-r1', 'group-1', 'profile-faculty-1', 'Prof. Rasika Ransing', 'faculty', 'Please present your system architecture and show the face detection module demo.', '{}', '2025-11-05 10:05:00'),
  ('rmsg-1-2', 'session-1-r1', 'group-1', 'profile-student-1', 'Arkan Khan', 'student', 'We have prepared the architecture diagram and a working prototype of the detection module.', '{}', '2025-11-05 10:10:00'),
  ('rmsg-1-3', 'session-1-r1', 'group-1', 'profile-faculty-1', 'Prof. Rasika Ransing', 'faculty', 'Good progress! The detection accuracy looks promising. Work on improving the lighting conditions handling before Review 2. Score: 85/100', '{}', '2025-11-05 10:55:00');

-- Group 2 Review 1 messages  
INSERT INTO "ReviewMessage" (id, "sessionId", "groupId", "authorId", "authorName", "authorRole", content, links, "createdAt")
VALUES
  ('rmsg-2-1', 'session-2-r1', 'group-2', 'profile-faculty-2', 'Prof. Neha Kudu', 'faculty', 'Show me the cloud architecture and the current state of the backend APIs.', '{}', '2025-11-06 14:05:00'),
  ('rmsg-2-2', 'session-2-r1', 'group-2', 'profile-student-4', 'Om Alve', 'student', 'Here is our AWS architecture diagram and the API documentation we have implemented so far.', '{}', '2025-11-06 14:15:00');

-- =====================================================
-- ATTACHMENTS (Sample file attachments for flexible system)
-- Note: These reference placeholder URLs - actual files need to be in Supabase Storage
-- NEW: No stage categorization - flexible uploads (max 5 per group)
-- =====================================================

-- Group 1: Has 3 files (demonstrating flexible uploads)
INSERT INTO "Attachment" (id, "groupId", filename, "fileUrl", "fileSize", "mimeType", "uploadedBy", "uploadedAt")
VALUES
  ('attach-1-1', 'group-1', 'Project_Proposal_IT01.pdf', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-1/files/Project_Proposal_IT01.pdf', 1048576, 'application/pdf', 'profile-student-1', '2025-10-30 10:00:00'),
  ('attach-1-2', 'group-1', 'System_Architecture.png', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-1/files/System_Architecture.png', 524288, 'image/png', 'profile-student-2', '2025-11-02 14:30:00'),
  ('attach-1-3', 'group-1', 'Progress_Report_Nov.docx', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-1/files/Progress_Report_Nov.docx', 786432, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'profile-student-1', '2025-11-05 09:00:00');

-- Group 2: Has 2 files
INSERT INTO "Attachment" (id, "groupId", filename, "fileUrl", "fileSize", "mimeType", "uploadedBy", "uploadedAt")
VALUES
  ('attach-2-1', 'group-2', 'Cloud_Architecture_Diagram.pdf', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-2/files/Cloud_Architecture_Diagram.pdf', 921600, 'application/pdf', 'profile-student-4', '2025-10-30 11:00:00'),
  ('attach-2-2', 'group-2', 'API_Documentation.pdf', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-2/files/API_Documentation.pdf', 1572864, 'application/pdf', 'profile-student-5', '2025-11-03 16:20:00');

-- Group 3: Has 5 files (maximum allowed)
INSERT INTO "Attachment" (id, "groupId", filename, "fileUrl", "fileSize", "mimeType", "uploadedBy", "uploadedAt")
VALUES
  ('attach-3-1', 'group-3', 'Project_Charter.pdf', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-3/files/Project_Charter.pdf', 655360, 'application/pdf', 'profile-student-7', '2025-10-29 15:00:00'),
  ('attach-3-2', 'group-3', 'Wireframes.zip', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-3/files/Wireframes.zip', 3145728, 'application/zip', 'profile-student-8', '2025-10-31 10:30:00'),
  ('attach-3-3', 'group-3', 'Database_Schema.png', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-3/files/Database_Schema.png', 412876, 'image/png', 'profile-student-9', '2025-11-01 12:00:00'),
  ('attach-3-4', 'group-3', 'Tech_Stack_Analysis.xlsx', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-3/files/Tech_Stack_Analysis.xlsx', 245760, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'profile-student-7', '2025-11-04 09:45:00'),
  ('attach-3-5', 'group-3', 'Sprint_1_Demo.pptx', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-3/files/Sprint_1_Demo.pptx', 2097152, 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 'profile-student-8', '2025-11-06 11:15:00');

-- Group 4: Has 1 file
INSERT INTO "Attachment" (id, "groupId", filename, "fileUrl", "fileSize", "mimeType", "uploadedBy", "uploadedAt")
VALUES
  ('attach-4-1', 'group-4', 'Initial_Proposal.pdf', 'https://placeholder.supabase.co/storage/v1/object/public/project-attachments/group-4/files/Initial_Proposal.pdf', 819200, 'application/pdf', 'profile-student-10', '2025-10-30 13:00:00');

-- =====================================================
-- ADDITIONAL DATA FOR MENTOR OVERVIEW FEATURE
-- =====================================================

-- Add 2 more groups that don't have mentors assigned (for manual allocation testing)
-- First, add 6 more students

INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES 
  ('user-student-13', 'student13@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-14', 'student14@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-15', 'student15@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-16', 'student16@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-17', 'student17@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-18', 'student18@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

INSERT INTO "Profile" (id, "userId", name, email, role, department, "rollNumber", semester, "createdAt", "updatedAt")
VALUES 
  ('profile-student-13', 'user-student-13', 'Maya Deshmukh', 'student13@gmail.com', 'student', 'IT', '22101A0013', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-14', 'user-student-14', 'Rohan Patil', 'student14@gmail.com', 'student', 'IT', '22101A0014', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-15', 'user-student-15', 'Priya Joshi', 'student15@gmail.com', 'student', 'IT', '22101A0015', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-16', 'user-student-16', 'Vikram Reddy', 'student16@gmail.com', 'student', 'IT', '22101A0016', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-17', 'user-student-17', 'Sneha Kulkarni', 'student17@gmail.com', 'student', 'IT', '22101A0017', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-18', 'user-student-18', 'Aditya Sharma', 'student18@gmail.com', 'student', 'IT', '22101A0018', 7, '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Update group counter
UPDATE "GroupCounter" SET counter = 6 WHERE department = 'IT';

-- Add 2 new groups without mentor allocation (for manual allocation testing)
INSERT INTO "Group" (id, "groupId", "teamCode", department, "createdBy", "isFull", "createdAt", "updatedAt")
VALUES 
  ('group-5', 'IT05', 'TEAM5', 'IT', 'profile-student-13', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('group-6', 'IT06', 'TEAM6', 'IT', 'profile-student-16', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Group 5 members
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-5-1', 'group-5', 'profile-student-13', '2025-10-29 10:00:00'),
  ('member-5-2', 'group-5', 'profile-student-14', '2025-10-29 10:00:00'),
  ('member-5-3', 'group-5', 'profile-student-15', '2025-10-29 10:00:00');

-- Group 6 members
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-6-1', 'group-6', 'profile-student-16', '2025-10-29 10:00:00'),
  ('member-6-2', 'group-6', 'profile-student-17', '2025-10-29 10:00:00'),
  ('member-6-3', 'group-6', 'profile-student-18', '2025-10-29 10:00:00');

-- Note: Groups 5 and 6 have NO mentor allocation - they will appear in the
-- "Unassigned Groups" list for manual allocation testing

-- =====================================================
-- SEMESTER FILTER TESTING DATA
-- Add groups with students from different semesters (5 and 6)
-- =====================================================

-- Add 6 more students from Semester 5
INSERT INTO "User" (id, email, password, "createdAt", "updatedAt")
VALUES 
  ('user-student-19', 'student19@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-20', 'student20@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-21', 'student21@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-22', 'student22@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-23', 'student23@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('user-student-24', 'student24@gmail.com', '$2a$10$5pp3A2nwzGLAGIq6TfDhOezLMrn1OeSg6O09SfAvxo62ekvWOvH5O', '2025-10-29 10:00:00', '2025-10-29 10:00:00');

INSERT INTO "Profile" (id, "userId", name, email, role, department, "rollNumber", semester, "createdAt", "updatedAt")
VALUES 
  ('profile-student-19', 'user-student-19', 'Ishaan Verma', 'student19@gmail.com', 'student', 'IT', '23101A0001', 5, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-20', 'user-student-20', 'Kavya Nair', 'student20@gmail.com', 'student', 'IT', '23101A0002', 5, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-21', 'user-student-21', 'Arjun Malhotra', 'student21@gmail.com', 'student', 'IT', '23101A0003', 5, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-22', 'user-student-22', 'Diya Gupta', 'student22@gmail.com', 'student', 'IT', '23101A0004', 6, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-23', 'user-student-23', 'Karan Singh', 'student23@gmail.com', 'student', 'IT', '23101A0005', 6, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('profile-student-24', 'user-student-24', 'Ananya Rao', 'student24@gmail.com', 'student', 'IT', '23101A0006', 6, '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Update group counter
UPDATE "GroupCounter" SET counter = 8 WHERE department = 'IT';

-- Add 2 groups: one from Semester 5, one from Semester 6
INSERT INTO "Group" (id, "groupId", "teamCode", department, "createdBy", "isFull", "createdAt", "updatedAt")
VALUES 
  ('group-7', 'IT07', 'TEAM7', 'IT', 'profile-student-19', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00'),
  ('group-8', 'IT08', 'TEAM8', 'IT', 'profile-student-22', true, '2025-10-29 10:00:00', '2025-10-29 10:00:00');

-- Group 7 members (Semester 5)
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-7-1', 'group-7', 'profile-student-19', '2025-10-29 10:00:00'),
  ('member-7-2', 'group-7', 'profile-student-20', '2025-10-29 10:00:00'),
  ('member-7-3', 'group-7', 'profile-student-21', '2025-10-29 10:00:00');

-- Group 8 members (Semester 6)
INSERT INTO "GroupMember" (id, "groupId", "profileId", "joinedAt")
VALUES 
  ('member-8-1', 'group-8', 'profile-student-22', '2025-10-29 10:00:00'),
  ('member-8-2', 'group-8', 'profile-student-23', '2025-10-29 10:00:00'),
  ('member-8-3', 'group-8', 'profile-student-24', '2025-10-29 10:00:00');

-- Assign mentors to new groups (for testing semester filter)
INSERT INTO "MentorAllocation" (id, "groupId", "mentorId", "preferenceRank", status, "createdAt", "updatedAt")
VALUES
  ('alloc-7', 'group-7', 'profile-faculty-1', 1, 'accepted', '2025-10-29 12:00:00', '2025-10-29 15:00:00'),
  ('alloc-8', 'group-8', 'profile-faculty-2', 1, 'accepted', '2025-10-29 12:00:00', '2025-10-29 15:00:00');

-- Add topics for new groups
INSERT INTO "ProjectTopic" (id, "groupId", title, description, status, "createdAt", "updatedAt")
VALUES
  ('topic-7', 'group-7', 'Mobile App Development Platform', 'A cross-platform mobile development framework using React Native', 'approved', '2025-10-30 10:00:00', '2025-11-01 09:00:00'),
  ('topic-8', 'group-8', 'Real-time Chat Application', 'WebSocket-based real-time messaging platform with end-to-end encryption', 'pending', '2025-10-30 11:00:00', '2025-10-30 11:00:00');

-- =====================================================
-- SEED DATA SUMMARY
-- =====================================================
-- Users: 1 Super Admin, 3 Faculty, 24 Students (password: 'password')
-- Groups: 8 groups of 3 students each
--   - 6 groups (IT01-IT04, IT07-IT08) have ACCEPTED mentors
--   - 2 groups (IT05-IT06) have NO mentor (for manual allocation testing)
--
-- Semester Distribution:
--   - Semester 5: 3 students (Group IT07)
--   - Semester 6: 3 students (Group IT08)
--   - Semester 7: 18 students (Groups IT01-IT06)
--
-- Mentor Allocations:
--   - IT01 (TEAM1) → Prof. Rasika Ransing (Faculty 1) ✓ [Semester 7]
--   - IT02 (TEAM2) → Prof. Neha Kudu (Faculty 2) ✓ [Semester 7]
--   - IT03 (TEAM3) → Prof. Vinita Bhandiwad (Faculty 3) ✓ [Semester 7]
--   - IT04 (TEAM4) → Prof. Kanchan Dhuri (Super Admin) ✓ [Semester 7]
--   - IT05 (TEAM5) → NO MENTOR (for manual allocation) [Semester 7]
--   - IT06 (TEAM6) → NO MENTOR (for manual allocation) [Semester 7]
--   - IT07 (TEAM7) → Prof. Rasika Ransing (Faculty 1) ✓ [Semester 5]
--   - IT08 (TEAM8) → Prof. Neha Kudu (Faculty 2) ✓ [Semester 6]
--
-- Project Topics:
--   - IT01: Approved (AI Attendance System)
--   - IT02: Approved (Cloud Project Management)
--   - IT03: Pending (Blockchain Certificates)
--   - IT04: Not submitted
--   - IT05/IT06: N/A (no mentor yet)
--   - IT07: Approved (Mobile App Platform)
--   - IT08: Pending (Real-time Chat App)
--
-- Attachments (Flexible System - No Stage):
--   - IT01: 3 files (PDF, PNG, DOCX)
--   - IT02: 2 files (PDFs)
--   - IT03: 5 files - MAX REACHED (PDF, ZIP, PNG, XLSX, PPTX)
--   - IT04: 1 file (PDF)
--   - IT05-IT08: No files yet
--
-- Reviews:
--   - IT01: Review 1 completed (85%)
--   - IT02: Review 1 in progress (60%)
--
-- Attachments:
--   - IT01: Topic proposal PDF, Review 1 presentation
--   - IT02: Topic proposal PDF
--
-- =====================================================
-- NEW FEATURES TO TEST
-- =====================================================
--
-- 1. MENTOR OVERVIEW (Superadmin Dashboard):
--    - Login as superadmin@gmail.com
--    - Go to Admin Dashboard → "Mentor & Group Overview" tab
--    - See all mentors with their assigned groups and progress
--    - Export data as CSV or PDF
--
-- 2. MANUAL ALLOCATION:
--    - In Admin Dashboard, click "Manual Allocation" button
--    - Groups IT05 and IT06 should appear as unassigned
--    - Select a group and assign a mentor
--
-- 3. ATTACHMENTS:
--    - Login as student1@gmail.com (IT01 team leader)
--    - Go to Project Progress → Attachments tab
--    - View/upload attachments for each review stage
--    - Only the team leader can upload files
--
-- =====================================================
-- LOGIN CREDENTIALS (all passwords: 'password'):
-- =====================================================
--   Super Admin: superadmin@gmail.com
--   Faculty:
--     - faculty1@gmail.com (Prof. Rasika Ransing)
--     - faculty2@gmail.com (Prof. Neha Kudu)
--     - faculty3@gmail.com (Prof. Vinita Bhandiwad)
--   Students (Team Leaders marked with *):
--     - IT01: student1@gmail.com* (Arkan), student2, student3
--     - IT02: student4@gmail.com* (Om), student5, student6
--     - IT03: student7@gmail.com* (Pratik), student8, student9
--     - IT04: student10@gmail.com* (Jack), student11, student12
--     - IT05: student13@gmail.com* (Maya), student14, student15
--     - IT06: student16@gmail.com* (Vikram), student17, student18
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
SELECT 'Review Messages', COUNT(*) FROM "ReviewMessage"
UNION ALL
SELECT 'Attachments', COUNT(*) FROM "Attachment"
UNION ALL
SELECT 'Topic Approval Docs', COUNT(*) FROM "TopicApprovalDocument"
UNION ALL
SELECT 'Review Evaluations', COUNT(*) FROM "ReviewEvaluation"
UNION ALL
SELECT 'Student Grades', COUNT(*) FROM "StudentGrade";

-- =====================================================
-- TOPIC APPROVAL DOCUMENTS (Sample uploaded forms)
-- =====================================================

-- IT01 has uploaded their topic approval document
INSERT INTO "TopicApprovalDocument" (id, "groupId", filename, "fileUrl", "uploaderId", "uploadedAt")
SELECT 
  'doc-it01',
  g.id,
  'Topic_Approval_IT01_Signed.pdf',
  'https://example.com/uploads/topic-approval-it01.pdf',
  g."createdBy",
  '2025-11-05 14:30:00'
FROM "Group" g
WHERE g."groupId" = 'IT01';

-- IT02 has uploaded their topic approval document
INSERT INTO "TopicApprovalDocument" (id, "groupId", filename, "fileUrl", "uploaderId", "uploadedAt")
SELECT 
  'doc-it02',
  g.id,
  'Topic_Approval_IT02_Signed.pdf',
  'https://example.com/uploads/topic-approval-it02.pdf',
  g."createdBy",
  '2025-11-06 09:15:00'
FROM "Group" g
WHERE g."groupId" = 'IT02';

-- =====================================================
-- REVIEW EVALUATIONS (Sample faculty grading forms)
-- =====================================================

-- Review 1 Evaluation for IT01 by Faculty 1
INSERT INTO "ReviewEvaluation" (id, "sessionId", "evaluatorId", "totalMarks", "maxMarks", remarks, "paperPublicationStatus", "submittedAt")
SELECT 
  'eval-r1-it01',
  rs.id,
  'profile-faculty-1',
  22,
  25,
  'Excellent progress. Team is well-coordinated and on track.',
  'In Progress - Submitted to IEEE Conference',
  '2025-11-20 16:45:00'
FROM "ReviewSession" rs
JOIN "Group" g ON rs."groupId" = g.id
WHERE g."groupId" = 'IT01' AND rs."reviewType" = 'review_1';

-- Student Grades for IT01 Review 1
INSERT INTO "StudentGrade" (id, "evaluationId", "studentId", "progressMarks", "contributionMarks", "totalMarks")
SELECT 
  'grade-r1-it01-s1',
  'eval-r1-it01',
  p.id,
  9,
  8,
  22
FROM "Profile" p
JOIN "GroupMember" gm ON p.id = gm."profileId"
JOIN "Group" g ON gm."groupId" = g.id
WHERE g."groupId" = 'IT01' AND p."rollNumber" = 'IT2021001'
UNION ALL
SELECT 
  'grade-r1-it01-s2',
  'eval-r1-it01',
  p.id,
  9,
  8,
  22
FROM "Profile" p
JOIN "GroupMember" gm ON p.id = gm."profileId"
JOIN "Group" g ON gm."groupId" = g.id
WHERE g."groupId" = 'IT01' AND p."rollNumber" = 'IT2021002'
UNION ALL
SELECT 
  'grade-r1-it01-s3',
  'eval-r1-it01',
  p.id,
  9,
  8,
  22
FROM "Profile" p
JOIN "GroupMember" gm ON p.id = gm."profileId"
JOIN "Group" g ON gm."groupId" = g.id
WHERE g."groupId" = 'IT01' AND p."rollNumber" = 'IT2021003';

-- Review 2 Evaluation for IT01 by Faculty 1
INSERT INTO "ReviewEvaluation" (id, "sessionId", "evaluatorId", "totalMarks", "maxMarks", remarks, "submittedAt")
SELECT 
  'eval-r2-it01',
  rs.id,
  'profile-faculty-1',
  23,
  25,
  'Outstanding presentation. Implementation is innovative and well-executed.',
  '2025-12-15 17:30:00'
FROM "ReviewSession" rs
JOIN "Group" g ON rs."groupId" = g.id
WHERE g."groupId" = 'IT01' AND rs."reviewType" = 'review_2';

-- Student Grades for IT01 Review 2
INSERT INTO "StudentGrade" (id, "evaluationId", "studentId", "techUsageMarks", "innovativenessMarks", "presentationMarks", "projectActivityMarks", "synopsisMarks", "totalMarks")
SELECT 
  'grade-r2-it01-s1',
  'eval-r2-it01',
  p.id,
  5,
  5,
  4,
  5,
  4,
  23
FROM "Profile" p
JOIN "GroupMember" gm ON p.id = gm."profileId"
JOIN "Group" g ON gm."groupId" = g.id
WHERE g."groupId" = 'IT01' AND p."rollNumber" = 'IT2021001'
UNION ALL
SELECT 
  'grade-r2-it01-s2',
  'eval-r2-it01',
  p.id,
  5,
  5,
  4,
  5,
  4,
  23
FROM "Profile" p
JOIN "GroupMember" gm ON p.id = gm."profileId"
JOIN "Group" g ON gm."groupId" = g.id
WHERE g."groupId" = 'IT01' AND p."rollNumber" = 'IT2021002'
UNION ALL
SELECT 
  'grade-r2-it01-s3',
  'eval-r2-it01',
  p.id,
  5,
  5,
  4,
  5,
  4,
  23
FROM "Profile" p
JOIN "GroupMember" gm ON p.id = gm."profileId"
JOIN "Group" g ON gm."groupId" = g.id
WHERE g."groupId" = 'IT01' AND p."rollNumber" = 'IT2021003';

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Show mentor overview summary
SELECT 
  p.name as mentor_name,
  p.email as mentor_email,
  COUNT(DISTINCT ma."groupId") as groups_assigned
FROM "Profile" p
LEFT JOIN "MentorAllocation" ma ON p.id = ma."mentorId" AND ma.status = 'accepted'
WHERE p.role IN ('faculty', 'super_admin')
GROUP BY p.id, p.name, p.email
ORDER BY groups_assigned DESC;

-- Show groups without mentors (for manual allocation testing)
SELECT 
  g."groupId",
  g."teamCode",
  leader.name as leader_name,
  COUNT(gm.id) as member_count
FROM "Group" g
JOIN "Profile" leader ON g."createdBy" = leader.id
JOIN "GroupMember" gm ON g.id = gm."groupId"
WHERE NOT EXISTS (
  SELECT 1 FROM "MentorAllocation" ma 
  WHERE ma."groupId" = g.id AND ma.status = 'accepted'
)
GROUP BY g.id, g."groupId", g."teamCode", leader.name
ORDER BY g."groupId";

-- =====================================================
-- PROJECT HUB - DEMO SEED DATA
-- =====================================================
-- This file contains SQL queries to seed the database with demo data
-- Run this after your schema is set up to populate with sample data
-- =====================================================

-- Clear existing data (in reverse order of dependencies)
DELETE FROM "ReviewMessage";
DELETE FROM "ReviewSession";
DELETE FROM "ReviewRollout";
DELETE FROM "TopicMessage";
DELETE FROM "ProjectTopic";
DELETE FROM "MentorAllocation";
DELETE FROM "MentorPreference";
DELETE FROM "MentorForm";
DELETE FROM "Group";
DELETE FROM "Profile";
DELETE FROM "User";

-- =====================================================
-- USERS
-- =====================================================
-- Note: Passwords should be hashed in your actual application
-- These are placeholder values - update with actual hashed passwords

-- Super Admin
INSERT INTO "User" (id, email, password, role, "createdAt", "updatedAt")
VALUES 
  ('admin-001', 'admin@admin.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'SUPER_ADMIN', NOW(), NOW());

-- Faculty Members
INSERT INTO "User" (id, email, password, role, "createdAt", "updatedAt")
VALUES 
  ('faculty-001', 'faculty1@faculty.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'FACULTY', NOW(), NOW()),
  ('faculty-002', 'faculty2@faculty.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'FACULTY', NOW(), NOW()),
  ('faculty-003', 'faculty3@faculty.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'FACULTY', NOW(), NOW()),
  ('faculty-004', 'faculty4@faculty.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'FACULTY', NOW(), NOW());

-- Students (15 students for 5 groups of 3)
INSERT INTO "User" (id, email, password, role, "createdAt", "updatedAt")
VALUES 
  -- Group 1
  ('student-001', 'student1@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-002', 'student2@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-003', 'student3@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  -- Group 2
  ('student-004', 'student4@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-005', 'student5@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-006', 'student6@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  -- Group 3
  ('student-007', 'student7@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-008', 'student8@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-009', 'student9@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  -- Group 4
  ('student-010', 'student10@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-011', 'student11@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-012', 'student12@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  -- Group 5
  ('student-013', 'student13@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-014', 'student14@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW()),
  ('student-015', 'student15@student.edu', '$2a$10$VvCxRN2EX53nRW8tm5ylNeKMQMsginrrnYQLLGz5r3ldDw0COr/Za', 'STUDENT', NOW(), NOW());

-- =====================================================
-- PROFILES
-- =====================================================

-- Admin Profile
INSERT INTO "Profile" (id, "userId", "fullName", department, "createdAt", "updatedAt")
VALUES 
  ('profile-admin-001', 'admin-001', 'System Administrator', 'Administration', NOW(), NOW());

-- Faculty Profiles
INSERT INTO "Profile" (id, "userId", "fullName", department, "createdAt", "updatedAt")
VALUES 
  ('profile-faculty-001', 'faculty-001', 'Dr. Sarah Smith', 'Computer Science', NOW(), NOW()),
  ('profile-faculty-002', 'faculty-002', 'Dr. Michael Johnson', 'Computer Science', NOW(), NOW()),
  ('profile-faculty-003', 'faculty-003', 'Dr. Emily Williams', 'Computer Science', NOW(), NOW()),
  ('profile-faculty-004', 'faculty-004', 'Dr. James Brown', 'Computer Science', NOW(), NOW());

-- Student Profiles
INSERT INTO "Profile" (id, "userId", "fullName", department, "createdAt", "updatedAt")
VALUES 
  ('profile-student-001', 'student-001', 'Alice Chen', 'Computer Science', NOW(), NOW()),
  ('profile-student-002', 'student-002', 'Bob Kumar', 'Computer Science', NOW(), NOW()),
  ('profile-student-003', 'student-003', 'Carol Garcia', 'Computer Science', NOW(), NOW()),
  ('profile-student-004', 'student-004', 'David Lee', 'Computer Science', NOW(), NOW()),
  ('profile-student-005', 'student-005', 'Emma Wilson', 'Computer Science', NOW(), NOW()),
  ('profile-student-006', 'student-006', 'Frank Martinez', 'Computer Science', NOW(), NOW()),
  ('profile-student-007', 'student-007', 'Grace Anderson', 'Computer Science', NOW(), NOW()),
  ('profile-student-008', 'student-008', 'Henry Thomas', 'Computer Science', NOW(), NOW()),
  ('profile-student-009', 'student-009', 'Isabel Rodriguez', 'Computer Science', NOW(), NOW()),
  ('profile-student-010', 'student-010', 'Jack Patel', 'Computer Science', NOW(), NOW()),
  ('profile-student-011', 'student-011', 'Kate Nguyen', 'Computer Science', NOW(), NOW()),
  ('profile-student-012', 'student-012', 'Liam Taylor', 'Computer Science', NOW(), NOW()),
  ('profile-student-013', 'student-013', 'Maya Ahmed', 'Computer Science', NOW(), NOW()),
  ('profile-student-014', 'student-014', 'Noah Kim', 'Computer Science', NOW(), NOW()),
  ('profile-student-015', 'student-015', 'Olivia Jackson', 'Computer Science', NOW(), NOW());

-- =====================================================
-- GROUPS
-- =====================================================

INSERT INTO "Group" (id, name, department, "createdAt", "updatedAt")
VALUES 
  ('group-001', 'Team Alpha', 'Computer Science', NOW(), NOW()),
  ('group-002', 'Team Beta', 'Computer Science', NOW(), NOW()),
  ('group-003', 'Team Gamma', 'Computer Science', NOW(), NOW()),
  ('group-004', 'Team Delta', 'Computer Science', NOW(), NOW()),
  ('group-005', 'Team Epsilon', 'Computer Science', NOW(), NOW());

-- Update student profiles with group memberships
UPDATE "Profile" SET "groupId" = 'group-001' WHERE id IN ('profile-student-001', 'profile-student-002', 'profile-student-003');
UPDATE "Profile" SET "groupId" = 'group-002' WHERE id IN ('profile-student-004', 'profile-student-005', 'profile-student-006');
UPDATE "Profile" SET "groupId" = 'group-003' WHERE id IN ('profile-student-007', 'profile-student-008', 'profile-student-009');
UPDATE "Profile" SET "groupId" = 'group-004' WHERE id IN ('profile-student-010', 'profile-student-011', 'profile-student-012');
UPDATE "Profile" SET "groupId" = 'group-005' WHERE id IN ('profile-student-013', 'profile-student-014', 'profile-student-015');

-- =====================================================
-- MENTOR FORMS
-- =====================================================

INSERT INTO "MentorForm" (id, "facultyId", department, capacity, expertise, availability, "createdAt", "updatedAt")
VALUES 
  ('mentor-form-001', 'faculty-001', 'Computer Science', 2, 'Machine Learning, AI, Data Science', 'Monday-Wednesday afternoons', NOW(), NOW()),
  ('mentor-form-002', 'faculty-002', 'Computer Science', 2, 'Web Development, Cloud Computing, DevOps', 'Tuesday-Thursday mornings', NOW(), NOW()),
  ('mentor-form-003', 'faculty-003', 'Computer Science', 2, 'Mobile Development, UI/UX, React Native', 'Wednesday-Friday afternoons', NOW(), NOW()),
  ('mentor-form-004', 'faculty-004', 'Computer Science', 1, 'Cybersecurity, Blockchain, Network Security', 'Monday-Friday mornings', NOW(), NOW());

-- =====================================================
-- MENTOR PREFERENCES
-- =====================================================

INSERT INTO "MentorPreference" (id, "studentId", "firstChoice", "secondChoice", "thirdChoice", "createdAt", "updatedAt")
VALUES 
  -- Group 1 preferences
  ('pref-001', 'student-001', 'faculty-001', 'faculty-002', 'faculty-003', NOW(), NOW()),
  ('pref-002', 'student-002', 'faculty-001', 'faculty-002', 'faculty-003', NOW(), NOW()),
  ('pref-003', 'student-003', 'faculty-001', 'faculty-003', 'faculty-002', NOW(), NOW()),
  -- Group 2 preferences
  ('pref-004', 'student-004', 'faculty-002', 'faculty-003', 'faculty-001', NOW(), NOW()),
  ('pref-005', 'student-005', 'faculty-002', 'faculty-001', 'faculty-003', NOW(), NOW()),
  ('pref-006', 'student-006', 'faculty-002', 'faculty-003', 'faculty-004', NOW(), NOW()),
  -- Group 3 preferences
  ('pref-007', 'student-007', 'faculty-003', 'faculty-002', 'faculty-001', NOW(), NOW()),
  ('pref-008', 'student-008', 'faculty-003', 'faculty-001', 'faculty-002', NOW(), NOW()),
  ('pref-009', 'student-009', 'faculty-003', 'faculty-002', 'faculty-004', NOW(), NOW()),
  -- Group 4 preferences
  ('pref-010', 'student-010', 'faculty-004', 'faculty-001', 'faculty-002', NOW(), NOW()),
  ('pref-011', 'student-011', 'faculty-004', 'faculty-002', 'faculty-003', NOW(), NOW()),
  ('pref-012', 'student-012', 'faculty-004', 'faculty-001', 'faculty-003', NOW(), NOW()),
  -- Group 5 preferences
  ('pref-013', 'student-013', 'faculty-001', 'faculty-002', 'faculty-003', NOW(), NOW()),
  ('pref-014', 'student-014', 'faculty-002', 'faculty-001', 'faculty-004', NOW(), NOW()),
  ('pref-015', 'student-015', 'faculty-001', 'faculty-003', 'faculty-002', NOW(), NOW());

-- =====================================================
-- MENTOR ALLOCATIONS
-- =====================================================

INSERT INTO "MentorAllocation" (id, "groupId", "facultyId", "allocatedBy", "createdAt", "updatedAt")
VALUES 
  ('allocation-001', 'group-001', 'faculty-001', 'admin-001', NOW(), NOW()),
  ('allocation-002', 'group-002', 'faculty-002', 'admin-001', NOW(), NOW()),
  ('allocation-003', 'group-003', 'faculty-003', 'admin-001', NOW(), NOW()),
  ('allocation-004', 'group-004', 'faculty-004', 'admin-001', NOW(), NOW()),
  ('allocation-005', 'group-005', 'faculty-001', 'admin-001', NOW(), NOW());

-- =====================================================
-- PROJECT TOPICS
-- =====================================================

-- Approved Topic (Group 1)
INSERT INTO "ProjectTopic" (id, "groupId", title, description, "technologyStack", objectives, status, "submittedBy", "submittedAt", "reviewedBy", "reviewedAt", "createdAt", "updatedAt")
VALUES 
  ('topic-001', 'group-001', 'AI-Powered Healthcare Diagnosis System', 
   'A machine learning system that assists doctors in diagnosing diseases based on patient symptoms and medical history. Uses deep learning models trained on large medical datasets.',
   'Python, TensorFlow, Flask, React, PostgreSQL',
   'Develop accurate diagnosis models, Create user-friendly interface for doctors, Ensure HIPAA compliance, Achieve 90% accuracy on test dataset',
   'APPROVED', 'student-001', NOW() - INTERVAL '5 days', 'faculty-001', NOW() - INTERVAL '3 days', NOW() - INTERVAL '5 days', NOW() - INTERVAL '3 days');

-- Under Review Topic (Group 2)
INSERT INTO "ProjectTopic" (id, "groupId", title, description, "technologyStack", objectives, status, "submittedBy", "submittedAt", "createdAt", "updatedAt")
VALUES 
  ('topic-002', 'group-002', 'Cloud-Based E-Commerce Platform',
   'A scalable microservices-based e-commerce platform deployed on AWS with features like real-time inventory management, payment processing, and recommendation engine.',
   'Node.js, Express, MongoDB, React, AWS (EC2, S3, Lambda), Docker, Kubernetes',
   'Implement microservices architecture, Build scalable infrastructure, Integrate payment gateways, Create recommendation system',
   'UNDER_REVIEW', 'student-004', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', NOW());

-- Revision Requested Topic (Group 3)
INSERT INTO "ProjectTopic" (id, "groupId", title, description, "technologyStack", objectives, status, "submittedBy", "submittedAt", "reviewedBy", "reviewedAt", feedback, "createdAt", "updatedAt")
VALUES 
  ('topic-003', 'group-003', 'Social Media Mobile App',
   'A mobile app for social networking with basic features like posts, likes, and comments.',
   'React Native, Firebase',
   'Create a social media app with posts and likes',
   'REVISION_REQUESTED', 'student-007', NOW() - INTERVAL '4 days', 'faculty-003', NOW() - INTERVAL '2 days',
   'The scope is too narrow. Please expand to include more advanced features like real-time messaging, story features, or content recommendation. Also specify the unique value proposition compared to existing platforms.',
   NOW() - INTERVAL '4 days', NOW() - INTERVAL '2 days');

-- Rejected Topic (Group 4)
INSERT INTO "ProjectTopic" (id, "groupId", title, description, "technologyStack", objectives, status, "submittedBy", "submittedAt", "reviewedBy", "reviewedAt", feedback, "createdAt", "updatedAt")
VALUES 
  ('topic-004', 'group-004', 'Simple Todo List Application',
   'A basic todo list app where users can add and delete tasks.',
   'HTML, CSS, JavaScript',
   'Build a todo app',
   'REJECTED', 'student-010', NOW() - INTERVAL '6 days', 'faculty-004', NOW() - INTERVAL '5 days',
   'This project is too simple for a final year project. Please propose a more complex system that demonstrates advanced software engineering concepts. Consider adding features like team collaboration, AI-powered task prioritization, or integration with project management tools.',
   NOW() - INTERVAL '6 days', NOW() - INTERVAL '5 days');

-- Newly Submitted Topic (Group 5)
INSERT INTO "ProjectTopic" (id, "groupId", title, description, "technologyStack", objectives, status, "submittedBy", "submittedAt", "createdAt", "updatedAt")
VALUES 
  ('topic-005', 'group-005', 'Smart Campus Management System',
   'An integrated platform for managing campus facilities including class scheduling, room booking, attendance tracking, and resource allocation using IoT sensors and predictive analytics.',
   'Java Spring Boot, Angular, MySQL, MQTT, TensorFlow, Redis',
   'Implement IoT sensor integration for occupancy tracking, Develop intelligent scheduling algorithm, Create real-time dashboard for administrators, Build predictive models for resource optimization',
   'SUBMITTED', 'student-013', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day', NOW());

-- =====================================================
-- TOPIC MESSAGES (Threaded Discussions)
-- =====================================================

-- Messages for Approved Topic (Group 1)
INSERT INTO "TopicMessage" (id, "topicId", "authorId", content, "createdAt", "updatedAt")
VALUES 
  ('topic-msg-001', 'topic-001', 'student-001', 'We have submitted our project topic for review. Looking forward to your feedback!', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
  ('topic-msg-002', 'topic-001', 'faculty-001', 'Great topic! The scope looks appropriate. Could you provide more details about the datasets you plan to use?', NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),
  ('topic-msg-003', 'topic-001', 'student-002', 'We plan to use the MIMIC-III clinical database and possibly combine it with CDC health survey data for better generalization.', NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),
  ('topic-msg-004', 'topic-001', 'faculty-001', 'Perfect! Topic approved. You can proceed with the project.', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
  ('topic-msg-005', 'topic-001', 'student-003', 'Thank you, Dr. Smith! We will start working on the architecture design.', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days');

-- Messages for Revision Requested Topic (Group 3)
INSERT INTO "TopicMessage" (id, "topicId", "authorId", content, "createdAt", "updatedAt")
VALUES 
  ('topic-msg-006', 'topic-003', 'student-007', 'Here is our proposed project topic for mobile app development.', NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),
  ('topic-msg-007', 'topic-003', 'faculty-003', 'The basic idea is good, but as mentioned in my feedback, please expand the scope to include more advanced features. What makes your app unique?', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
  ('topic-msg-008', 'topic-003', 'student-008', 'We understand. We will revise the proposal to include real-time video messaging and an AI-powered content moderation system.', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day');

-- Messages for Under Review Topic (Group 2)
INSERT INTO "TopicMessage" (id, "topicId", "authorId", content, "createdAt", "updatedAt")
VALUES 
  ('topic-msg-009', 'topic-002', 'student-004', 'Submitted our e-commerce platform proposal. We have experience with microservices from our internships.', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
  ('topic-msg-010', 'topic-002', 'student-005', 'Happy to answer any questions about the architecture or technology choices!', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days');

-- =====================================================
-- REVIEW ROLLOUTS
-- =====================================================

-- Review 1 is currently active
INSERT INTO "ReviewRollout" (id, department, "reviewType", "startDate", "endDate", "isActive", "createdBy", "createdAt", "updatedAt")
VALUES 
  ('rollout-001', 'Computer Science', 'REVIEW_1', NOW() - INTERVAL '7 days', NOW() + INTERVAL '7 days', true, 'admin-001', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days');

-- Review 2 was completed last month
INSERT INTO "ReviewRollout" (id, department, "reviewType", "startDate", "endDate", "isActive", "createdBy", "createdAt", "updatedAt")
VALUES 
  ('rollout-002', 'Computer Science', 'REVIEW_2', NOW() - INTERVAL '45 days', NOW() - INTERVAL '30 days', false, 'admin-001', NOW() - INTERVAL '45 days', NOW() - INTERVAL '30 days');

-- =====================================================
-- REVIEW SESSIONS
-- =====================================================

-- Review 1 Sessions (Active)

-- Group 1 - Completed Review 1
INSERT INTO "ReviewSession" (id, "groupId", "reviewType", progress, "progressDescription", status, "submittedBy", "submittedAt", feedback, "reviewedBy", "reviewedAt", "createdAt", "updatedAt")
VALUES 
  ('review-session-001', 'group-001', 'REVIEW_1', 85, 
   'We have completed the data collection phase and built the initial ML model. Current accuracy is 82% on validation set. We are now working on feature engineering to improve performance. Architecture diagram and database schema are finalized.',
   'COMPLETED', 'student-001', NOW() - INTERVAL '3 days', 
   'Excellent progress! Your model performance is on track. For the next phase, focus on model interpretability and start building the backend API. Consider implementing SHAP values for explaining predictions to doctors.',
   'faculty-001', NOW() - INTERVAL '2 days', NOW() - INTERVAL '3 days', NOW() - INTERVAL '2 days');

-- Group 2 - Feedback Given for Review 1
INSERT INTO "ReviewSession" (id, "groupId", "reviewType", progress, "progressDescription", status, "submittedBy", "submittedAt", feedback, "reviewedBy", "reviewedAt", "createdAt", "updatedAt")
VALUES 
  ('review-session-002', 'group-002', 'REVIEW_1', 70,
   'Microservices architecture is defined with 5 core services (User, Product, Order, Payment, Inventory). Implemented User and Product services with Docker containers. Set up CI/CD pipeline. Currently working on integrating services with API Gateway.',
   'FEEDBACK_GIVEN', 'student-004', NOW() - INTERVAL '2 days',
   'Good architectural design. However, I recommend implementing proper service discovery (Consul or Eureka) and distributed tracing (Jaeger) early on. Also, add comprehensive API documentation using Swagger.',
   'faculty-002', NOW() - INTERVAL '1 day', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day');

-- Group 3 - Progress Submitted for Review 1
INSERT INTO "ReviewSession" (id, "groupId", "reviewType", progress, "progressDescription", status, "submittedBy", "submittedAt", "createdAt", "updatedAt")
VALUES 
  ('review-session-003', 'group-003', 'REVIEW_1', 60,
   'After receiving revision feedback, we have expanded our scope. Now including real-time video chat (WebRTC), AI content moderation (TensorFlow), and AR filters. Completed UI/UX wireframes and technical architecture. Started implementing authentication and user profile modules.',
   'PROGRESS_SUBMITTED', 'student-007', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day', NOW());

-- Group 5 - Progress Submitted for Review 1
INSERT INTO "ReviewSession" (id, "groupId", "reviewType", progress, "progressDescription", status, "submittedBy", "submittedAt", "createdAt", "updatedAt")
VALUES 
  ('review-session-004', 'group-005', 'REVIEW_1', 75,
   'IoT sensor integration prototype is working with MQTT broker. Built real-time dashboard showing occupancy data. Implemented basic room booking system. Working on the predictive analytics module using historical data.',
   'PROGRESS_SUBMITTED', 'student-013', NOW() - INTERVAL '6 hours', NOW() - INTERVAL '6 hours', NOW());

-- Review 2 Sessions (Completed from last month)

-- Group 1 - Completed Review 2
INSERT INTO "ReviewSession" (id, "groupId", "reviewType", progress, "progressDescription", status, "submittedBy", "submittedAt", feedback, "reviewedBy", "reviewedAt", "createdAt", "updatedAt")
VALUES 
  ('review-session-005', 'group-001', 'REVIEW_2', 95,
   'Backend API completed with all endpoints. Frontend with React is 90% complete. Model accuracy improved to 89%. Integrated SHAP for interpretability. Completed unit and integration tests. System is deployed on staging environment.',
   'COMPLETED', 'student-001', NOW() - INTERVAL '32 days',
   'Outstanding work! The model interpretability feature is impressive. Make sure to complete comprehensive user testing with actual doctors before final review. Also prepare detailed documentation.',
   'faculty-001', NOW() - INTERVAL '31 days', NOW() - INTERVAL '32 days', NOW() - INTERVAL '31 days');

-- =====================================================
-- REVIEW MESSAGES (Threaded Discussions)
-- =====================================================

-- Messages for Group 1 Review 1
INSERT INTO "ReviewMessage" (id, "sessionId", "authorId", content, "createdAt", "updatedAt")
VALUES 
  ('review-msg-001', 'review-session-001', 'student-001', 'We have submitted our Review 1 progress. Please find the attached documentation and model performance report.', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
  ('review-msg-002', 'review-session-001', 'faculty-001', 'Reviewed your submission. The progress is excellent. Have you considered edge cases for rare diseases?', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
  ('review-msg-003', 'review-session-001', 'student-002', 'Yes, we are collecting additional data for rare diseases and planning to use transfer learning to improve performance on those cases.', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
  ('review-msg-004', 'review-session-001', 'faculty-001', 'Perfect approach. Marking this as complete. Keep up the good work!', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days');

-- Messages for Group 2 Review 1
INSERT INTO "ReviewMessage" (id, "sessionId", "authorId", content, "createdAt", "updatedAt")
VALUES 
  ('review-msg-005', 'review-session-002', 'student-004', 'Progress update submitted. We have demonstrated the microservices communication in our demo video.', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
  ('review-msg-006', 'review-session-002', 'faculty-002', 'The architecture looks solid. As mentioned in feedback, please prioritize service discovery and monitoring.', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
  ('review-msg-007', 'review-session-002', 'student-005', 'Understood. We will integrate Consul for service discovery this week and add Prometheus for monitoring.', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
  ('review-msg-008', 'review-session-002', 'student-006', 'Also planning to add circuit breaker pattern using Resilience4j for fault tolerance.', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day');

-- Messages for Group 3 Review 1  
INSERT INTO "ReviewMessage" (id, "sessionId", "authorId", content, "createdAt", "updatedAt")
VALUES 
  ('review-msg-009', 'review-session-003', 'student-007', 'After revising our topic, we have made good progress. The expanded scope is proving to be very interesting!', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
  ('review-msg-010', 'review-session-003', 'student-008', 'WebRTC implementation for video chat is working in our prototype. Next we will integrate the AI content moderation.', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day');

-- Messages for Group 5 Review 1
INSERT INTO "ReviewMessage" (id, "sessionId", "authorId", content, "createdAt", "updatedAt")
VALUES 
  ('review-msg-011', 'review-session-004', 'student-013', 'Our IoT sensors are successfully collecting real-time occupancy data. Dashboard is looking great!', NOW() - INTERVAL '6 hours', NOW() - INTERVAL '6 hours'),
  ('review-msg-012', 'review-session-004', 'student-014', 'We are using LSTM networks for predicting room usage patterns. Initial results are promising.', NOW() - INTERVAL '5 hours', NOW() - INTERVAL '5 hours');

-- =====================================================
-- SEED DATA SUMMARY
-- =====================================================
-- Users: 1 Admin, 4 Faculty, 15 Students
-- Groups: 5 groups of 3 students each
-- Mentor Allocations: All groups have assigned mentors
-- Project Topics: 5 topics in various states (approved, under_review, revision_requested, rejected, submitted)
-- Review Rollouts: Review 1 active, Review 2 completed
-- Review Sessions: 4 sessions for Review 1 (various states), 1 session for Review 2
-- Messages: 12 topic messages, 12 review messages
-- =====================================================

-- Verify data
SELECT 'Users' as entity, COUNT(*) as count FROM "User"
UNION ALL
SELECT 'Profiles', COUNT(*) FROM "Profile"
UNION ALL
SELECT 'Groups', COUNT(*) FROM "Group"
UNION ALL
SELECT 'Mentor Forms', COUNT(*) FROM "MentorForm"
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

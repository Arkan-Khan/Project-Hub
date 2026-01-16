export type Role = "student" | "faculty" | "super_admin";

export type Department = "IT" | "CS" | "ECS" | "ETC" | "BM";

export interface User {
  id: string;
  email: string;
  createdAt: string;
}

export interface Profile {
  id: string;
  userId: string;
  name: string;
  email: string;
  role: Role;
  department: Department;
  rollNumber?: string; // For students
  semester?: number; // For students
  createdAt: string;
}

export interface Group {
  id: string;
  groupId: string; // e.g., IT03
  teamCode: string; // e.g., A7DXQ
  department: Department;
  createdBy: string; // profile id of leader
  members: string[]; // array of profile ids
  isFull: boolean; // true if members.length >= 3
  createdAt: string;
}

export interface MentorAllocationForm {
  id: string;
  department: Department;
  isActive: boolean;
  createdBy: string; // super admin profile id
  availableMentors: string[]; // array of faculty profile ids
  createdAt: string;
}

export interface MentorPreference {
  id: string;
  groupId: string;
  formId: string;
  mentorChoices: [string, string, string]; // exactly 3 mentor profile ids (1st, 2nd, 3rd preference)
  submittedBy: string; // leader profile id
  submittedAt: string;
}

export interface MentorAllocation {
  id: string;
  groupId: string;
  mentorId: string;
  formId: string;
  status: "pending" | "accepted" | "rejected";
  preferenceRank: number; // 1, 2, or 3
  createdAt: string;
  updatedAt: string;
}

export const ACCESS_CODES: Record<Department, string> = {
  IT: "ITADMIN2025",
  CS: "CSADMIN2025",
  ECS: "ECSADMIN2025",
  ETC: "ETCADMIN2025",
  BM: "BMADMIN2025",
};

// ============================================
// Topic Approval Types
// ============================================

export type TopicStatus =
  | "submitted"
  | "under_review"
  | "approved"
  | "rejected"
  | "revision_requested";

export interface ProjectTopic {
  id: string;
  groupId: string;
  title: string;
  description: string;
  status: TopicStatus;
  submittedBy: string; // profile id
  submittedAt: string;
  reviewedBy?: string; // mentor profile id
  reviewedAt?: string;
}

export interface TopicMessage {
  id: string;
  topicId: string; // can be "general" for general discussion
  groupId: string;
  authorId: string;
  authorName: string;
  authorRole: "student" | "faculty";
  content: string;
  links?: string[]; // optional URLs
  createdAt: string;
}

// ============================================
// Review Types
// ============================================

export type ReviewType = "review_1" | "review_2" | "final_review";

export type ReviewStatus =
  | "not_started"
  | "in_progress"
  | "submitted"
  | "feedback_given"
  | "completed";

export interface ReviewRollout {
  id: string;
  department: Department;
  reviewType: ReviewType;
  isActive: boolean;
  createdBy: string; // super admin profile id
  createdAt: string;
}

export interface ReviewSession {
  id: string;
  groupId: string;
  reviewType: ReviewType;
  status: ReviewStatus;
  progressPercentage: number; // 0-100
  progressDescription: string;
  submittedBy: string; // student profile id
  submittedAt: string;
  mentorFeedback?: string;
  feedbackGivenBy?: string; // mentor profile id
  feedbackGivenAt?: string;
}

export interface ReviewMessage {
  id: string;
  sessionId: string;
  groupId: string;
  authorId: string;
  authorName: string;
  authorRole: "student" | "faculty";
  content: string;
  links?: string[];
  createdAt: string;
}

// ============================================
// Team Progress (Aggregated View)
// ============================================

export interface TeamProgress {
  groupId: string;
  groupDisplayId: string; // e.g., "IT03"
  mentorId: string;
  mentorName: string;
  topicApproval: {
    status: "pending" | "approved" | "rejected";
    approvedTopic?: string;
    totalTopicsSubmitted: number;
  };
  review1: {
    status: ReviewStatus;
    progressPercentage?: number;
    isRolledOut: boolean;
  };
  review2: {
    status: ReviewStatus;
    progressPercentage?: number;
    isRolledOut: boolean;
  };
  finalReview: {
    status: ReviewStatus;
    progressPercentage?: number;
    isRolledOut: boolean;
  };
}


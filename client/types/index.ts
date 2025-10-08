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


/**
 * localStorage abstraction layer
 * This makes it easy to swap with Supabase later
 */

import {
  User,
  Profile,
  Group,
  MentorAllocationForm,
  MentorPreference,
  MentorAllocation,
  Department,
} from "@/types";

// Storage keys
const KEYS = {
  USERS: "projecthub_users",
  PROFILES: "projecthub_profiles",
  GROUPS: "projecthub_groups",
  MENTOR_FORMS: "projecthub_mentor_forms",
  MENTOR_PREFERENCES: "projecthub_mentor_preferences",
  MENTOR_ALLOCATIONS: "projecthub_mentor_allocations",
  CURRENT_USER: "projecthub_current_user",
  GROUP_COUNTERS: "projecthub_group_counters",
};

// Helper to generate IDs
export const generateId = () => {
  return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
};

// Helper to generate group serial number
const getNextGroupSerial = (department: Department): number => {
  const counters = JSON.parse(
    localStorage.getItem(KEYS.GROUP_COUNTERS) || "{}"
  ) as Record<Department, number>;
  const current = counters[department] || 0;
  const next = current + 1;
  counters[department] = next;
  localStorage.setItem(KEYS.GROUP_COUNTERS, JSON.stringify(counters));
  return next;
};

// Helper to generate team code
export const generateTeamCode = (): string => {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // Removed confusing chars
  let code = "";
  for (let i = 0; i < 5; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
};

// ============ USER & AUTH ============

export const createUser = (email: string, password: string): User => {
  const users = JSON.parse(localStorage.getItem(KEYS.USERS) || "[]") as User[];

  // Check if user exists
  if (users.find((u) => u.email === email)) {
    throw new Error("User already exists");
  }

  const user: User = {
    id: generateId(),
    email,
    createdAt: new Date().toISOString(),
  };

  users.push(user);
  localStorage.setItem(KEYS.USERS, JSON.stringify(users));

  // Store password separately (in real app, this would be hashed)
  const passwords = JSON.parse(
    localStorage.getItem("projecthub_passwords") || "{}"
  );
  passwords[user.email] = password;
  localStorage.setItem("projecthub_passwords", JSON.stringify(passwords));

  return user;
};

export const loginUser = (email: string, password: string): User => {
  const users = JSON.parse(localStorage.getItem(KEYS.USERS) || "[]") as User[];
  const passwords = JSON.parse(
    localStorage.getItem("projecthub_passwords") || "{}"
  );

  const user = users.find((u) => u.email === email);
  if (!user || passwords[email] !== password) {
    throw new Error("Invalid credentials");
  }

  localStorage.setItem(KEYS.CURRENT_USER, JSON.stringify(user));
  return user;
};

export const getCurrentUser = (): User | null => {
  const user = localStorage.getItem(KEYS.CURRENT_USER);
  return user ? JSON.parse(user) : null;
};

export const logoutUser = () => {
  localStorage.removeItem(KEYS.CURRENT_USER);
};

// ============ PROFILE ============

export const createProfile = (
  profileData: Omit<Profile, "id" | "createdAt">
): Profile => {
  const profiles = JSON.parse(
    localStorage.getItem(KEYS.PROFILES) || "[]"
  ) as Profile[];

  const profile: Profile = {
    ...profileData,
    id: generateId(),
    createdAt: new Date().toISOString(),
  };

  profiles.push(profile);
  localStorage.setItem(KEYS.PROFILES, JSON.stringify(profiles));

  return profile;
};

export const getProfileByUserId = (userId: string): Profile | null => {
  const profiles = JSON.parse(
    localStorage.getItem(KEYS.PROFILES) || "[]"
  ) as Profile[];
  return profiles.find((p) => p.userId === userId) || null;
};

export const getProfileById = (profileId: string): Profile | null => {
  const profiles = JSON.parse(
    localStorage.getItem(KEYS.PROFILES) || "[]"
  ) as Profile[];
  return profiles.find((p) => p.id === profileId) || null;
};

export const getProfilesByRole = (role: string): Profile[] => {
  const profiles = JSON.parse(
    localStorage.getItem(KEYS.PROFILES) || "[]"
  ) as Profile[];
  return profiles.filter((p) => p.role === role);
};

export const getProfilesByDepartment = (department: Department): Profile[] => {
  const profiles = JSON.parse(
    localStorage.getItem(KEYS.PROFILES) || "[]"
  ) as Profile[];
  return profiles.filter((p) => p.department === department);
};

export const getFacultyByDepartment = (department: Department): Profile[] => {
  return getProfilesByDepartment(department).filter(
    (p) => p.role === "faculty" || p.role === "super_admin"
  );
};

// ============ GROUP ============

export const createGroup = (
  createdBy: string,
  department: Department
): Group => {
  const groups = JSON.parse(
    localStorage.getItem(KEYS.GROUPS) || "[]"
  ) as Group[];

  const serial = getNextGroupSerial(department);
  const groupId = `${department}${serial.toString().padStart(2, "0")}`;

  const group: Group = {
    id: generateId(),
    groupId,
    teamCode: generateTeamCode(),
    department,
    createdBy,
    members: [createdBy],
    isFull: false,
    createdAt: new Date().toISOString(),
  };

  groups.push(group);
  localStorage.setItem(KEYS.GROUPS, JSON.stringify(groups));

  return group;
};

export const getGroupByTeamCode = (teamCode: string): Group | null => {
  const groups = JSON.parse(
    localStorage.getItem(KEYS.GROUPS) || "[]"
  ) as Group[];
  return groups.find((g) => g.teamCode === teamCode) || null;
};

export const getGroupByMemberId = (memberId: string): Group | null => {
  const groups = JSON.parse(
    localStorage.getItem(KEYS.GROUPS) || "[]"
  ) as Group[];
  return groups.find((g) => g.members.includes(memberId)) || null;
};

export const joinGroup = (teamCode: string, memberId: string): Group => {
  const groups = JSON.parse(
    localStorage.getItem(KEYS.GROUPS) || "[]"
  ) as Group[];

  const groupIndex = groups.findIndex((g) => g.teamCode === teamCode);
  if (groupIndex === -1) {
    throw new Error("Group not found");
  }

  const group = groups[groupIndex];

  if (group.members.includes(memberId)) {
    throw new Error("Already a member of this group");
  }

  if (group.members.length >= 3) {
    throw new Error("Group is full (max 3 members)");
  }

  group.members.push(memberId);
  group.isFull = group.members.length >= 3;

  localStorage.setItem(KEYS.GROUPS, JSON.stringify(groups));

  return group;
};

export const getGroupsByDepartment = (department: Department): Group[] => {
  const groups = JSON.parse(
    localStorage.getItem(KEYS.GROUPS) || "[]"
  ) as Group[];
  return groups.filter((g) => g.department === department);
};

// ============ MENTOR ALLOCATION FORM ============

export const createMentorAllocationForm = (
  department: Department,
  createdBy: string,
  availableMentors: string[]
): MentorAllocationForm => {
  const forms = JSON.parse(
    localStorage.getItem(KEYS.MENTOR_FORMS) || "[]"
  ) as MentorAllocationForm[];

  // Deactivate any existing active forms for this department
  forms.forEach((f) => {
    if (f.department === department && f.isActive) {
      f.isActive = false;
    }
  });

  const form: MentorAllocationForm = {
    id: generateId(),
    department,
    isActive: true,
    createdBy,
    availableMentors,
    createdAt: new Date().toISOString(),
  };

  forms.push(form);
  localStorage.setItem(KEYS.MENTOR_FORMS, JSON.stringify(forms));

  return form;
};

export const getActiveMentorForm = (
  department: Department
): MentorAllocationForm | null => {
  const forms = JSON.parse(
    localStorage.getItem(KEYS.MENTOR_FORMS) || "[]"
  ) as MentorAllocationForm[];
  return forms.find((f) => f.department === department && f.isActive) || null;
};

// ============ MENTOR PREFERENCES ============

export const submitMentorPreferences = (
  groupId: string,
  formId: string,
  mentorChoices: [string, string, string],
  submittedBy: string
): MentorPreference => {
  const preferences = JSON.parse(
    localStorage.getItem(KEYS.MENTOR_PREFERENCES) || "[]"
  ) as MentorPreference[];

  // Check if preferences already submitted
  if (preferences.find((p) => p.groupId === groupId && p.formId === formId)) {
    throw new Error("Preferences already submitted for this group");
  }

  const preference: MentorPreference = {
    id: generateId(),
    groupId,
    formId,
    mentorChoices,
    submittedBy,
    submittedAt: new Date().toISOString(),
  };

  preferences.push(preference);
  localStorage.setItem(KEYS.MENTOR_PREFERENCES, JSON.stringify(preferences));

  // Create pending allocations for each mentor choice
  const allocations = JSON.parse(
    localStorage.getItem(KEYS.MENTOR_ALLOCATIONS) || "[]"
  ) as MentorAllocation[];

  mentorChoices.forEach((mentorId, index) => {
    const allocation: MentorAllocation = {
      id: generateId(),
      groupId,
      mentorId,
      formId,
      status: "pending",
      preferenceRank: index + 1,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    allocations.push(allocation);
  });

  localStorage.setItem(KEYS.MENTOR_ALLOCATIONS, JSON.stringify(allocations));

  return preference;
};

export const getMentorPreferenceByGroup = (
  groupId: string
): MentorPreference | null => {
  const preferences = JSON.parse(
    localStorage.getItem(KEYS.MENTOR_PREFERENCES) || "[]"
  ) as MentorPreference[];
  return preferences.find((p) => p.groupId === groupId) || null;
};

// ============ MENTOR ALLOCATIONS ============

export const getAllocationsForMentor = (
  mentorId: string
): MentorAllocation[] => {
  const allocations = JSON.parse(
    localStorage.getItem(KEYS.MENTOR_ALLOCATIONS) || "[]"
  ) as MentorAllocation[];
  return allocations.filter((a) => a.mentorId === mentorId);
};

export const getAllocationsForGroup = (groupId: string): MentorAllocation[] => {
  const allocations = JSON.parse(
    localStorage.getItem(KEYS.MENTOR_ALLOCATIONS) || "[]"
  ) as MentorAllocation[];
  return allocations.filter((a) => a.groupId === groupId);
};

export const acceptMentorAllocation = (allocationId: string): void => {
  const allocations = JSON.parse(
    localStorage.getItem(KEYS.MENTOR_ALLOCATIONS) || "[]"
  ) as MentorAllocation[];

  const index = allocations.findIndex((a) => a.id === allocationId);
  if (index === -1) {
    throw new Error("Allocation not found");
  }

  const allocation = allocations[index];
  allocation.status = "accepted";
  allocation.updatedAt = new Date().toISOString();

  // Reject all other allocations for this group
  allocations.forEach((a) => {
    if (a.groupId === allocation.groupId && a.id !== allocationId) {
      a.status = "rejected";
      a.updatedAt = new Date().toISOString();
    }
  });

  localStorage.setItem(KEYS.MENTOR_ALLOCATIONS, JSON.stringify(allocations));
};

export const rejectMentorAllocation = (allocationId: string): void => {
  const allocations = JSON.parse(
    localStorage.getItem(KEYS.MENTOR_ALLOCATIONS) || "[]"
  ) as MentorAllocation[];

  const index = allocations.findIndex((a) => a.id === allocationId);
  if (index === -1) {
    throw new Error("Allocation not found");
  }

  allocations[index].status = "rejected";
  allocations[index].updatedAt = new Date().toISOString();

  localStorage.setItem(KEYS.MENTOR_ALLOCATIONS, JSON.stringify(allocations));
};


# ProjectHub — Context for Cursor Setup

This file defines the entire context for Cursor AI to understand the ProjectHub app’s structure and build everything till Mentor Allocation Form.  
You can paste or place this file directly as `context.md` inside your project root.  

---

## 🎯 GOAL
Build all functionality up to the **Mentor Allocation Form** stage.  
Focus on clean modular architecture, responsive UI, and correct role-based flow.  
Do NOT hallucinate or infer features beyond the details given below.

---

## 🧱 STACK & DESIGN RULES
**Frontend:** Next.js (App Router) + TypeScript  
**UI:** Shadcn/UI + TailwindCSS  
**Auth & DB:** Supabase  
**Icons:** Lucide-react  
**Style Theme:**
- Flat dual-tone palette only  
  - Primary: Indigo `#4F46E5`  
  - Accent: Amber `#FBBF24`  
- Background: pure white (`#FFFFFF`)  
- ❌ No gradients, glassmorphism, or purple tints.  
- UI must feel clean, academic, and minimal — like a modern college admin portal.  

**Structure:**
/app → routes
/components → reusable UI
/lib → Supabase client, helpers
/types → interfaces

yaml
Copy code

---

## 📘 APP OVERVIEW
ProjectHub manages college project workflows (mini → minor → major projects) for students and mentors.  
This version will handle user onboarding, group creation, and mentor allocation.

Build these key modules:
1. Landing Page  
2. Authentication + Onboarding  
3. Dashboards (Student / Faculty / Super Admin)  
4. Group/Team Management  
5. Mentor Allocation Form  

---

## 👥 USER ROLES

| Role | Description | Key Abilities |
|------|--------------|----------------|
| **Student** | Forms groups, submits mentor preferences | Create/join group, view members, submit mentor preferences |
| **Faculty (Mentor)** | Guides project teams | View and accept teams who selected them |
| **Super Admin (Coordinator)** | One per department | Roll out mentor allocation form, manage mentors, monitor allocations |

Departments: `IT`, `CS`, `ECS`, `ETC`, `BM`

---

## 🔐 AUTH & ONBOARDING

Use **Supabase Auth (email + password)**.  
After sign-up, redirect to onboarding.

**Onboarding Fields:**
- Common: `Name`, `Email`, `Department`, `Role`
- If Student → add `Roll Number`, `Semester`
- If Super Admin → ask `Access Code`

**Access Codes for Super Admin:**
IT → ITADMIN2025
CS → CSADMIN2025
ECS → ECSADMIN2025
ETC → ETCADMIN2025
BM → BMADMIN2025

yaml
Copy code
Invalid codes → show toast `"Invalid coordinator access code"`  
Store all onboarding data in a `profiles` table linked to Supabase users.

---

## 🧭 DASHBOARD STRUCTURE

### 🧑‍🎓 Student Dashboard
- If no team → show:
  - **Create Group**: Generates `group_id` = `<DEPT><serial>` (ex: IT03), and random `team_code` (e.g. `A7DXQ`). Creator = leader.  
  - **Join Group**: Enter `team_code`. Must match department and restrict to **max 3 members**.
- When group exists → display:
  - Group ID, Team Code, Members
  - If Mentor Allocation Form is active → show “Fill Mentor Allocation Form”
  - Only leader can fill form.

---

### 🧑‍🏫 Faculty Dashboard
- Show teams that selected them with preference rank (1–3)
- Actions: “Accept” or “Reject”
- Once accepted → mark mentor assignment as finalized.

---

### 🧑‍💼 Super Admin Dashboard
- Limited to department data only.
- “Roll Out Mentor Allocation Form” button → activates form for that department.
- Can select available mentors to include in the form.
- Basic summary view of teams and mentors.

---

## 📄 MENTOR ALLOCATION FORM FLOW

1. **Rollout:**  
   Super Admin starts form for their department. Chooses available mentors.

2. **Student Preference:**  
   - Only team leader fills it.  
   - Select exactly **3 mentor preferences** (no duplicates).  
   - Save preferences → lock submission for that team.

3. **Faculty Selection:**  
   - Faculty dashboard lists teams who selected them.  
   - Can “Accept Team”.  
   - Once accepted → update all views accordingly.

4. **Visibility:**  
   - Student dashboard → show mentor and status (pending/accepted).  
   - Faculty dashboard → show accepted team(s).  
   - Super Admin → can view summary of all allocations.

---

## 🗄️ DATABASE STRUCTURE (Supabase)

**profiles**  
`id, user_id, name, email, role, department, roll_number, semester`

**groups**  
`id, group_id, team_code, department, created_by (profile_id), members (relation), is_full`

**mentor_allocation_forms**  
`id, department, is_active, created_by (superadmin_id), available_mentors (relation)`

**mentor_preferences**  
`id, group_id, form_id, mentor_choices (array of 3 mentor_ids), submitted_by (leader_id)`

**mentor_allocations**  
`id, group_id, mentor_id, form_id, status ("pending", "accepted")`

---

## 🎨 UI REQUIREMENTS

- White background only — no gradient or purple shades.  
- Primary elements (buttons, headers): Indigo `#4F46E5`  
- Accent highlights (badges, form buttons): Amber `#FBBF24`  
- Use `shadcn/ui` components for all forms, modals, and cards.  
- Provide toast feedback for every key action.

---

## 🚀 DEV REQUIREMENTS
- Modular, clean architecture.  
- Isolate Supabase client in `/lib/supabase.ts`.  
- Use context or hook for user + role state.  
- Responsive dashboard layouts.  
- Avoid unnecessary animations or fancy effects.  
- Build only till **Mentor Allocation Flow completion**.

---

## ✅ MILESTONE TARGET
By end of this prompt:
- Role-based onboarding flow  
- Super Admin access code validation  
- Group creation + joining system with validation  
- Mentor Allocation Form (rollout, submission, acceptance)  
- Functional dashboards for all 3 roles  
- Clean, academic, minimal UI with dual-tone palette

---

Keep your reasoning deterministic.  
If confused, prefer explicit rules from this prompt instead of guessing.  
Avoid adding new pages, popups, or styles not mentioned.

You must stop after implementing the above scope.  
Future prompts will connect Supabase DB and refine APIs.
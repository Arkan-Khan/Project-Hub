# ProjectHub - College Project Management System

A comprehensive platform for students, faculty, and administrators to manage college projects (mini, minor, and major projects) with mentor allocation functionality.

## 🚀 Features

### For Students
- **Group Management**: Create or join project groups (max 3 members)
- **Mentor Preferences**: Submit top 3 mentor choices (leader only)
- **Real-time Status**: View mentor allocation status
- **Department-specific**: Groups restricted to same department

### For Faculty (Mentors)
- **My Teams Section**: Clear view of all teams you're currently mentoring
- **Request Management**: View teams that selected you as mentor
- **Accept/Reject**: Manage mentor requests with preference rankings
- **Team Overview**: See team members and their details  
- **Dashboard Stats**: Track your mentored teams, pending requests, and total requests

### For Super Admin (Coordinators)
- **Form Rollout**: Activate mentor allocation forms for department
- **Mentor Selection**: Choose which faculty members are available (can also select themselves)
- **Department Overview**: Monitor all groups and allocations
- **Access Control**: Department-specific admin codes
- **Dual Role**: Can also act as mentors and receive team requests

## 🛠️ Tech Stack

- **Frontend**: Next.js 15 (App Router) + TypeScript
- **Backend**: NestJS with PostgreSQL (Supabase)
- **UI**: TailwindCSS with custom Shadcn/UI components
- **Database**: PostgreSQL via Supabase with Prisma ORM
- **Authentication**: JWT-based auth with email/password
- **Icons**: Lucide React

## 📦 Installation

1. **Clone the repository**
   ```bash
   cd ProjectHub
   ```

2. **Set up environment variables**
   ```bash
   cp .env.local.example .env.local
   ```
   
   Edit `.env.local` and set:
   ```
   NEXT_PUBLIC_API_URL=http://localhost:3001/api
   ```

3. **Install dependencies**
   ```bash
   npm install
   ```

4. **Ensure backend is running**
   - The client requires the NestJS backend to be running
   - See `/server/README.md` for backend setup instructions
   - Backend should be running on `http://localhost:3001`

5. **Run development server**
   ```bash
   npm run dev
   ```

4. **Open browser**
   ```
   http://localhost:3000
   ```

## 🎨 Design System

- **Primary Color**: Indigo `#4F46E5`
- **Accent Color**: Amber `#FBBF24`
- **Background**: Pure White `#FFFFFF`
- **Style**: Clean, minimal, academic interface

## 👥 User Roles & Access

### Student
1. Sign up → Complete onboarding with:
   - Name, Email, Department
   - Roll Number & Semester
2. Create/Join group
3. Submit mentor preferences (leader only)

### Faculty
1. Sign up → Complete onboarding with:
   - Name, Email, Department
2. View teams requesting mentorship
3. Accept/Reject teams
4. Monitor all accepted teams in "My Teams" section

### Super Admin
1. Sign up → Complete onboarding with:
   - Name, Email, Department
   - **Access Code** (department-specific)
2. Roll out mentor allocation form (can include self as mentor)
3. Monitor all groups and allocations
4. Switch to "Mentor View" to see team requests if selected as available mentor

## 🔐 Super Admin Access Codes

| Department | Access Code |
|------------|-------------|
| IT | ITADMIN2025 |
| CS | CSADMIN2025 |
| ECS | ECSADMIN2025 |
| ETC | ETCADMIN2025 |
| BM | BMADMIN2025 |

## 📝 User Flow

### Complete Workflow Example

1. **Faculty Registration**
   - Faculty members sign up and complete onboarding

2. **Super Admin Setup**
   - Super Admin rolls out mentor allocation form
   - Selects available faculty mentors

3. **Student Group Formation**
   - Students create groups (leader gets unique Group ID + Team Code)
   - Other students join using Team Code
   - Groups limited to 3 members from same department

4. **Mentor Preference Submission**
   - Group leader selects 3 mentor preferences
   - Preferences locked after submission

5. **Faculty Response**
   - Faculty see teams with preference rankings
   - Accept one team (others auto-rejected)

6. **Completion**
   - Students see assigned mentor
   - Admin monitors all allocations

## 🗂️ Project Structure

```
ProjectHUb/
├── app/
│   ├── auth/
│   │   ├── login/page.tsx
│   │   └── signup/page.tsx
│   ├── dashboard/
│   │   ├── student/
│   │   │   ├── page.tsx
│   │   │   └── mentor-preferences/page.tsx
│   │   ├── faculty/page.tsx
│   │   ├── admin/page.tsx
│   │   └── page.tsx
│   ├── onboarding/page.tsx
│   ├── layout.tsx
│   ├── page.tsx
│   └── globals.css
├── components/
│   ├── ui/
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── input.tsx
│   │   ├── select.tsx
│   │   └── toast.tsx
│   └── dashboard-layout.tsx
├── lib/
│   ├── auth-context.tsx
│   └── storage.ts (localStorage abstraction)
├── types/
│   └── index.ts
└── README.md
```

## 💾 Data Storage (localStorage)

Currently using localStorage for rapid prototyping. Data structure:

- `projecthub_users` - User accounts
- `projecthub_profiles` - User profiles with role data
- `projecthub_groups` - Project groups
- `projecthub_mentor_forms` - Active allocation forms
- `projecthub_mentor_preferences` - Student submissions
- `projecthub_mentor_allocations` - Allocation status

### Ready for Supabase Migration

The `lib/storage.ts` file is designed as an abstraction layer. To migrate to Supabase:
1. Replace localStorage functions with Supabase queries
2. Keep the same function signatures
3. No changes needed in components

## 🔄 Group ID Generation

Groups get unique IDs based on department:
- Format: `{DEPT}{SERIAL}`
- Examples: `IT01`, `CS03`, `ECS12`
- Team codes: 5-character alphanumeric (e.g., `A7DXQ`)

## 🎯 Key Validation Rules

1. **Groups**:
   - Max 3 members
   - Same department only
   - Unique team codes

2. **Mentor Preferences**:
   - Exactly 3 mentors required
   - No duplicates
   - Leader-only submission
   - One submission per group

3. **Mentor Acceptance**:
   - Faculty can accept one team
   - Accepting one rejects others for that group

4. **Access Codes**:
   - Department-specific
   - Required for Super Admin only
   - Case-sensitive

## 🚧 Future Enhancements (Out of Scope)

- Supabase integration for multi-user real-time features
- Project progress tracking
- Document uploads
- Meeting scheduling
- Evaluation forms
- Email notifications

## 📱 Responsive Design

Fully responsive layouts:
- Mobile: Stacked cards, full-width buttons
- Tablet: 2-column grids
- Desktop: Multi-column layouts with sidebars

## 🐛 Development

```bash
# Install dependencies
npm install

# Run dev server
npm run dev

# Build for production
npm build

# Start production server
npm start
```

## 📄 License

This project is built for educational purposes as part of college project management.

---

Built with ❤️ using Next.js, TypeScript, and TailwindCSS


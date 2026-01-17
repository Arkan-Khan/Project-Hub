# ProjectHub - College Project Management System

A comprehensive full-stack platform for students, faculty, and administrators to manage college projects (mini, minor, and major projects) with mentor allocation functionality.

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

### Frontend
- **Framework**: Next.js 15 (App Router) with TypeScript
- **Styling**: TailwindCSS with custom Shadcn/UI components
- **Icons**: Lucide React
- **State Management**: React Context API

### Backend
- **Framework**: NestJS with TypeScript
- **Database**: PostgreSQL (via Supabase)
- **ORM**: Prisma
- **Authentication**: JWT with bcrypt password hashing
- **API**: RESTful with validation pipes

## 📚 Documentation

- **[Complete Project Documentation](docs/PROJECT_DOCUMENTATION.md)** - Comprehensive guide covering setup, architecture, API reference, database schema, and troubleshooting
- **[Backend README](server/README.md)** - NestJS backend details
- **[Frontend README](client/README.md)** - Next.js frontend details

## 🚀 Quick Start

### Prerequisites
- Node.js v18+
- Supabase account (free tier works)
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd Project-Hub
   ```

2. **Follow the [Complete Documentation](docs/PROJECT_DOCUMENTATION.md)** for detailed instructions

**OR** Quick start:

```bash
# Backend
cd server
npm install
cp .env.example .env  # Add your DATABASE_URL
npx prisma db push
npm run start:dev

# Frontend (new terminal)
cd client
npm install
cp .env.local.example .env.local
npm run dev
```

3. **Open browser**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:3001/api

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

## 📊 Project Status

✅ **Backend Complete** - 40+ API endpoints  
✅ **Frontend Complete** - Full integration with backend  
✅ **Database Complete** - PostgreSQL with Prisma ORM  
✅ **Documentation Complete** - Comprehensive guides  
✅ **Production Ready** - Fully functional system

See [INTEGRATION_COMPLETE.md](INTEGRATION_COMPLETE.md) for detailed status.

## 🤝 Contributing

This is a college project. Feel free to fork and adapt for your institution!

## 📄 License

MIT License - Free for educational use
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
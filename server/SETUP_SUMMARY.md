# ProjectHub Backend - Complete Setup Summary

## 🎉 What's Been Built

A complete NestJS backend with:

✅ **Authentication System**
- Email/password signup and login
- JWT-based authentication
- Secure password hashing with bcrypt

✅ **User Management**
- Role-based access (Student, Faculty, Super Admin)
- Department-based organization
- Profile onboarding with validation

✅ **Group Management**
- Create groups with auto-generated IDs (e.g., IT01, IT02)
- Join groups via team codes (e.g., A7DXQ)
- Max 3 members per group
- Department-based restrictions

✅ **Mentor Allocation System**
- Super admins can roll out allocation forms
- Select available mentors for students to choose from
- Students submit 3 mentor preferences (ranked)
- Faculty can accept/reject teams
- Automatic status tracking

✅ **Database Schema**
- PostgreSQL (Supabase) with Prisma ORM
- Type-safe enums for roles, departments, statuses
- Proper relationships and constraints
- Auto-incrementing group counters per department

## 📁 Project Structure

```
server/
├── prisma/
│   └── schema.prisma           # Database schema with enums
├── src/
│   ├── auth/                   # Authentication & JWT
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── guards/jwt-auth.guard.ts
│   │   ├── strategies/jwt.strategy.ts
│   │   └── dto/
│   ├── users/                  # User management
│   │   ├── users.service.ts
│   │   └── users.module.ts
│   ├── profiles/               # User profiles & onboarding
│   │   ├── profiles.controller.ts
│   │   ├── profiles.service.ts
│   │   └── dto/create-profile.dto.ts
│   ├── groups/                 # Group/team management
│   │   ├── groups.controller.ts
│   │   ├── groups.service.ts
│   │   └── dto/join-group.dto.ts
│   ├── mentor-forms/           # Mentor allocation forms
│   │   ├── mentor-forms.controller.ts
│   │   ├── mentor-forms.service.ts
│   │   └── dto/create-mentor-form.dto.ts
│   ├── mentor-preferences/     # Student preferences
│   │   ├── mentor-preferences.controller.ts
│   │   ├── mentor-preferences.service.ts
│   │   └── dto/submit-preferences.dto.ts
│   ├── mentor-allocations/     # Allocation management
│   │   ├── mentor-allocations.controller.ts
│   │   └── mentor-allocations.service.ts
│   ├── prisma/                 # Database service
│   │   ├── prisma.service.ts
│   │   └── prisma.module.ts
│   ├── app.module.ts           # Main app module
│   └── main.ts                 # Entry point
├── .env                        # Environment variables (Supabase URL)
├── .env.example               # Template
├── package.json
├── tsconfig.json
├── README.md                   # API documentation
├── SUPABASE_SETUP.md          # Database setup guide
└── API_TESTING.md             # Testing guide
```

## 🚀 Quick Start

### 1. Setup Supabase
Follow [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) to:
- Create a Supabase project
- Get your connection string
- Configure `.env`

### 2. Install & Run
```bash
# Install dependencies
npm install

# Generate Prisma client
npm run db:generate

# Push schema to database
npm run db:push

# Start development server
npm run start:dev
```

Server runs on: `http://localhost:3001`

### 3. Test the API
Follow [API_TESTING.md](./API_TESTING.md) to test all endpoints.

## 🔑 Key Features

### Role-Based Access Control
- **Students**: Create/join groups, submit mentor preferences
- **Faculty**: View and accept/reject team requests
- **Super Admin**: Roll out allocation forms, manage department

### Department-Based Isolation
Each department (IT, CS, ECS, ETC, BM) operates independently:
- Separate group counters
- Department-specific forms
- Faculty only see their department's students

### Super Admin Access Codes
Required for super admin registration:
- IT: `ITADMIN2025`
- CS: `CSADMIN2025`
- ECS: `ECSADMIN2025`
- ETC: `ETCADMIN2025`
- BM: `BMADMIN2025`

### Automatic Group ID Generation
Groups get unique IDs per department:
- First IT group: `IT01`
- Second IT group: `IT02`
- First CS group: `CS01`

### Team Codes
Random 5-character codes for joining groups:
- Example: `A7DXQ`, `K3PYM`
- Avoids confusing characters (0, O, I, 1, etc.)

## 📊 Database Tables

| Table | Purpose |
|-------|---------|
| User | Authentication (email, password) |
| Profile | User details with role & department |
| Group | Student teams |
| GroupMember | Group membership (many-to-many) |
| MentorAllocationForm | Forms created by admins |
| AvailableMentor | Selectable mentors per form |
| MentorPreference | Student's 3 mentor choices |
| MentorAllocation | Allocation status (pending/accepted/rejected) |
| GroupCounter | Auto-increment per department |

## 🔒 Security Features

- Passwords hashed with bcrypt (10 rounds)
- JWT tokens with 7-day expiration
- Protected routes with guards
- Role-based authorization
- Input validation with class-validator
- CORS enabled for frontend

## 🛠 Available Scripts

```bash
npm run start:dev      # Development with hot reload
npm run start:prod     # Production mode
npm run build          # Build for production
npm run db:generate    # Generate Prisma client
npm run db:push        # Push schema to database
npm run db:studio      # Open Prisma Studio GUI
npm run lint           # Lint code
npm run format         # Format code with Prettier
```

## 📚 API Documentation

See [README.md](./README.md) for complete API documentation with all endpoints and examples.

## 🔄 Integration with Frontend

The backend is designed to work seamlessly with the Next.js frontend:

1. **Authentication Flow**:
   - Frontend → POST `/api/auth/signup` → Backend
   - Backend returns JWT token
   - Frontend stores token, redirects to onboarding

2. **Protected Requests**:
   - All requests include: `Authorization: Bearer <token>`
   - Backend validates JWT and extracts user ID

3. **CORS Configuration**:
   - Accepts requests from `http://localhost:3000`
   - Credentials enabled for cookie support (if needed later)

## 🎯 What Matches the Frontend Requirements

✅ All storage.ts functions have equivalent API endpoints
✅ Same data structures and types
✅ Role validation matches frontend expectations
✅ Access codes validated server-side
✅ Group creation/joining logic identical
✅ Mentor preference submission flow complete
✅ Allocation accept/reject functionality ready

## 📝 Next Steps

1. **Connect Frontend**: Update frontend to use API instead of localStorage
2. **Test Full Flow**: Test complete user journey end-to-end
3. **Add Features**: Implement remaining features from Context.md
4. **Deploy**: Deploy backend to hosting service (Render, Railway, etc.)

## 🐛 Troubleshooting

**Can't connect to database?**
- Check DATABASE_URL in `.env`
- Verify Supabase project is running
- Check firewall/network settings

**Prisma errors?**
- Run `npm run db:generate` after schema changes
- Run `npm run db:push` to sync database

**Authentication errors?**
- Check JWT_SECRET is set in `.env`
- Verify token format: `Bearer <token>`

**CORS errors?**
- Check frontend URL in `main.ts` CORS config
- Ensure credentials are enabled if needed

## 📞 Support Files

- **README.md** - Complete API documentation
- **SUPABASE_SETUP.md** - Database setup instructions
- **API_TESTING.md** - Testing guide with curl examples
- **prisma/schema.prisma** - Database schema documentation

---

**Built with**: NestJS + Prisma + PostgreSQL (Supabase) + JWT
**Status**: ✅ Complete and ready for integration

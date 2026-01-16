# ProjectHub - Complete Setup Guide

This guide will walk you through setting up the complete ProjectHub system with both backend and frontend.

## Prerequisites

- **Node.js**: v18 or higher
- **PostgreSQL**: Via Supabase account (or local PostgreSQL)
- **Package Manager**: npm or yarn

## Part 1: Backend Setup (NestJS)

### 1. Navigate to server directory
```bash
cd server
```

### 2. Install dependencies
```bash
npm install
```

### 3. Configure Supabase Database

1. Create a free Supabase account at https://supabase.com
2. Create a new project
3. Go to Project Settings → Database
4. Copy the connection string (it looks like: `postgresql://postgres:[password]@[host]:5432/postgres`)

### 4. Set up environment variables

Create a `.env` file in the `server/` directory:

```env
DATABASE_URL="your-supabase-connection-string"
JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"
```

**Important**: Replace `your-supabase-connection-string` with your actual Supabase connection string.

### 5. Initialize the database

```bash
# Generate Prisma Client
npx prisma generate

# Push schema to database
npx prisma db push
```

### 6. (Optional) View database with Prisma Studio

```bash
npm run db:studio
```

This opens a GUI at http://localhost:5555 to view and edit your database.

### 7. Start the backend server

```bash
npm run start:dev
```

The backend will start on **http://localhost:3001**

You should see:
```
[Nest] Application successfully started
[Nest] Running on http://localhost:3001
```

## Part 2: Frontend Setup (Next.js)

### 1. Open a new terminal and navigate to client directory
```bash
cd client
```

### 2. Install dependencies
```bash
npm install
```

### 3. Set up environment variables

Create a `.env.local` file in the `client/` directory:

```env
NEXT_PUBLIC_API_URL=http://localhost:3001/api
```

### 4. Start the frontend development server

```bash
npm run dev
```

The frontend will start on **http://localhost:3000**

## Part 3: Testing the Application

### 1. Create a Super Admin Account

1. Go to http://localhost:3000
2. Click "Sign Up"
3. Enter email and password
4. After signup, you'll be redirected to onboarding
5. Fill in the form:
   - **Name**: Your name
   - **Email**: Same as signup
   - **Role**: Super Admin
   - **Department**: Choose your department (e.g., IT)
   - **Access Code**: Use department code:
     - IT: `ITADMIN2025`
     - CS: `CSADMIN2025`
     - ECS: `ECSADMIN2025`
     - ETC: `ETCADMIN2025`
     - BM: `BMADMIN2025`

### 2. Create Faculty Accounts

1. Sign out
2. Sign up with a new email
3. During onboarding, select:
   - **Role**: Faculty
   - **Department**: Same as your admin department
   - **No access code needed** for faculty

Repeat to create 2-3 faculty members.

### 3. Roll Out Mentor Allocation Form (As Super Admin)

1. Log in as super admin
2. You'll be on the Admin Dashboard
3. Scroll to "Mentor Allocation Form"
4. Select faculty members to be available as mentors
5. Click "Roll Out Form"

### 4. Create Student Accounts and Groups

1. Sign out
2. Create a student account
3. During onboarding:
   - **Role**: Student
   - **Department**: Same as admin department
   - **Roll Number**: e.g., IT2023001
   - **Semester**: 5

4. On Student Dashboard:
   - Click "Create New Group" to create a group
   - Note the **Team Code** displayed

5. Create 2 more student accounts
6. Have them join the group using the team code

### 5. Submit Mentor Preferences (As Group Leader)

1. Log in as the first student (group leader)
2. Click "Submit Mentor Preferences"
3. Select your top 3 mentor choices
4. Submit

### 6. Accept/Reject Teams (As Faculty)

1. Log in as one of the faculty members
2. You'll see pending requests from teams that selected you
3. View team members and preference rank
4. Click "Accept" or "Reject"

### 7. Verify Allocation (As Student)

1. Log back in as student
2. Check the dashboard to see if a mentor accepted your team

## API Documentation

Complete API documentation is available at:
- **File**: `/server/API_DOCUMENTATION.md`
- **Testing Guide**: `/server/API_TESTING.md`

## Troubleshooting

### Backend won't start

**Error**: `Error: P1001: Can't reach database server`
- **Solution**: Check your DATABASE_URL in `.env`
- Verify your Supabase project is running
- Check if your IP is allowed in Supabase settings

**Error**: `Prisma schema file not found`
- **Solution**: Make sure you're in the `server/` directory
- Run `npx prisma generate`

### Frontend won't connect to backend

**Error**: Network errors or "Failed to fetch"
- **Solution**: Ensure backend is running on port 3001
- Check `NEXT_PUBLIC_API_URL` in `.env.local`
- Verify CORS is enabled (it's configured by default)

### JWT Token expired

- **Solution**: Simply log out and log back in
- Tokens are valid for 7 days by default

### "Access code is invalid" error

- **Solution**: Use the correct department code:
  - IT: `ITADMIN2025`
  - CS: `CSADMIN2025`
  - ECS: `ECSADMIN2025`
  - ETC: `ETCADMIN2025`
  - BM: `BMADMIN2025`

### Can't join a group

**Possible reasons**:
- Group is full (max 3 members)
- You're already in another group
- Department mismatch
- Invalid team code

## Project Structure

```
Project-Hub/
├── server/                 # NestJS Backend
│   ├── prisma/
│   │   └── schema.prisma  # Database schema
│   ├── src/
│   │   ├── auth/          # Authentication module
│   │   ├── profiles/      # User profiles
│   │   ├── groups/        # Team management
│   │   ├── mentor-forms/  # Form rollout
│   │   ├── mentor-preferences/  # Student preferences
│   │   └── mentor-allocations/  # Faculty responses
│   ├── .env               # Backend environment variables
│   └── API_DOCUMENTATION.md
│
├── client/                # Next.js Frontend
│   ├── app/
│   │   ├── auth/          # Login/Signup pages
│   │   ├── onboarding/    # Profile creation
│   │   └── dashboard/     # Role-based dashboards
│   ├── lib/
│   │   ├── api-client.ts  # HTTP client
│   │   ├── api.ts         # API service layer
│   │   └── auth-context.tsx  # Auth state
│   └── .env.local         # Frontend environment variables
│
└── docs/                  # Documentation
```

## Development Workflow

### Making Changes to Database

1. Edit `server/prisma/schema.prisma`
2. Run `npx prisma db push` to apply changes
3. Run `npx prisma generate` to update Prisma Client
4. Restart backend server

### Adding New API Endpoints

1. Create/update controller and service in backend
2. Test with curl or Postman
3. Add TypeScript interface in `client/types/index.ts`
4. Add API method in `client/lib/api.ts`
5. Use in component

### Debugging

**Backend logs**:
- Check terminal where `npm run start:dev` is running
- Errors are logged with stack traces

**Frontend logs**:
- Check browser console (F12)
- Network tab shows API requests/responses

**Database**:
- Use Prisma Studio: `npm run db:studio` in server directory
- Or use Supabase Table Editor in dashboard

## Production Deployment

### Backend (NestJS)

1. Set production environment variables
2. Build: `npm run build`
3. Start: `npm run start:prod`
4. Deploy to Heroku, Railway, or similar

### Frontend (Next.js)

1. Update `NEXT_PUBLIC_API_URL` to production backend URL
2. Build: `npm run build`
3. Deploy to Vercel, Netlify, or similar

### Database

- Supabase handles production database automatically
- Enable Row Level Security (RLS) for additional security
- Set up backups in Supabase dashboard

## Support

For issues or questions:
- Check [API Documentation](server/API_DOCUMENTATION.md)
- Check [API Testing Guide](server/API_TESTING.md)
- Review [Supabase Setup Guide](server/SUPABASE_SETUP.md)
- Open an issue on GitHub

## License

MIT License - feel free to use for your college projects!

# ProjectHub - Quick Reference Card

## 🚀 Quick Start Commands

### Backend (Terminal 1)
```bash
cd server
npm install
npx prisma db push
npm run start:dev
# Server runs on http://localhost:3001
```

### Frontend (Terminal 2)
```bash
cd client
npm install
npm run dev
# App runs on http://localhost:3000
```

## 🔑 Access Codes

| Department | Code |
|------------|------|
| IT | `ITADMIN2025` |
| CS | `CSADMIN2025` |
| ECS | `ECSADMIN2025` |
| ETC | `ETCADMIN2025` |
| BM | `BMADMIN2025` |

## 📡 Key API Endpoints

### Authentication
```bash
POST /api/auth/signup
POST /api/auth/login
GET  /api/auth/me
```

### Profiles
```bash
POST /api/profiles
GET  /api/profiles/me
GET  /api/profiles/faculty/:department
```

### Groups
```bash
POST /api/groups/create
POST /api/groups/join
GET  /api/groups/my-group
```

### Mentor Forms
```bash
POST /api/mentor-forms
GET  /api/mentor-forms/active
```

### Mentor Preferences
```bash
POST /api/mentor-preferences
GET  /api/mentor-preferences/my-preferences
```

### Mentor Allocations
```bash
GET  /api/mentor-allocations/for-mentor
POST /api/mentor-allocations/:id/accept
POST /api/mentor-allocations/:id/reject
```

## 🗄️ Database Commands

```bash
# View database in GUI
npm run db:studio

# Reset database (caution!)
npx prisma db push --force-reset

# Generate Prisma Client
npx prisma generate

# View connection string
echo $DATABASE_URL
```

## 🔧 Environment Variables

### Backend (.env)
```env
DATABASE_URL="postgresql://..."
JWT_SECRET="your-secret-key"
```

### Frontend (.env.local)
```env
NEXT_PUBLIC_API_URL=http://localhost:3001/api
```

## 🎭 User Roles & Routes

| Role | Route | Access |
|------|-------|--------|
| **Student** | `/dashboard/student` | Group management, preferences |
| **Faculty** | `/dashboard/faculty` | Team requests, accept/reject |
| **Super Admin** | `/dashboard/admin` | Form rollout, overview |

## 📝 Testing Flow

1. **Create Super Admin** → Use access code
2. **Create Faculty** → No access code needed
3. **Roll Out Form** → Select faculty as mentors
4. **Create Students** → Form groups (max 3)
5. **Submit Preferences** → Group leader picks 3 mentors
6. **Accept Teams** → Faculty accepts/rejects
7. **Check Status** → Students see assigned mentor

## 🐛 Debugging

### Backend Logs
```bash
# Backend terminal shows:
- API requests
- Database queries
- Validation errors
- Stack traces
```

### Frontend Logs
```bash
# Browser console (F12):
- Network tab → API calls
- Console → JavaScript errors
- Application → localStorage/tokens
```

### Database
```bash
# Prisma Studio
npm run db:studio
# Or use Supabase Table Editor
```

## 🔍 Common Issues

**"Can't reach database"**
→ Check DATABASE_URL, verify Supabase is active

**"Token expired"**
→ Log out and log back in

**"Not authenticated"**
→ Check localStorage for 'projecthub_token'

**"Validation failed"**
→ Check API docs for required fields

**"Group is full"**
→ Max 3 members per group

**"Already in a group"**
→ Can only join one group

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| [SETUP_GUIDE.md](SETUP_GUIDE.md) | Complete setup walkthrough |
| [API_DOCUMENTATION.md](server/API_DOCUMENTATION.md) | All API endpoints |
| [API_TESTING.md](server/API_TESTING.md) | curl test examples |
| [INTEGRATION_COMPLETE.md](INTEGRATION_COMPLETE.md) | Project status |

## 🔗 Important Links

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001/api
- **Prisma Studio**: http://localhost:5555
- **Supabase Dashboard**: https://supabase.com/dashboard

## 💾 Useful Code Snippets

### Get JWT Token from Browser
```javascript
localStorage.getItem('projecthub_token')
```

### Test API with curl
```bash
# Get token first (from login response)
TOKEN="your-jwt-token"

# Use in requests
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:3001/api/profiles/me
```

### Check TypeScript Errors
```bash
# Frontend
cd client
npx tsc --noEmit

# Backend
cd server
npx tsc --noEmit
```

## 🎨 UI Components

All components in `client/components/ui/`:
- `button.tsx` - Primary action buttons
- `card.tsx` - Content containers
- `input.tsx` - Form inputs
- `select.tsx` - Dropdown selects
- `toast.tsx` - Notifications

## 🔐 JWT Token Structure

```json
{
  "userId": "uuid",
  "email": "user@example.com",
  "iat": 1234567890,
  "exp": 1234567890
}
```

Tokens expire after **7 days**.

## 📊 Database Models

- `User` → Authentication
- `Profile` → User details + role
- `Group` → Teams
- `GroupMember` → Team membership
- `MentorAllocationForm` → Active forms
- `AvailableMentor` → Selectable faculty
- `MentorPreference` → Student choices
- `MentorAllocation` → Individual requests
- `GroupCounter` → Auto-increment IDs

## 🎓 Business Logic

**Group Creation:**
1. Auto-generate group ID (IT01, CS01, etc.)
2. Generate random 5-char team code
3. Add creator as first member

**Preference Submission:**
1. Validate: leader, 3 unique choices
2. Create 3 allocation records (pending)
3. Mark preferences as submitted

**Faculty Acceptance:**
1. Update allocation to 'accepted'
2. Auto-reject other allocations for same group
3. Transaction ensures atomicity

## 🌟 Pro Tips

- Use **Prisma Studio** to view/edit database directly
- Check **Network tab** for API response details
- Use **localStorage** to inspect JWT tokens
- Backend **auto-restarts** on file changes
- Frontend **hot-reloads** automatically
- All **timestamps** in ISO 8601 format

---

**Need help?** Check [SETUP_GUIDE.md](SETUP_GUIDE.md) or [API_DOCUMENTATION.md](server/API_DOCUMENTATION.md)

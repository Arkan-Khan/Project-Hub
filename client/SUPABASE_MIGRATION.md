# 🔄 Supabase Migration Guide

This guide will help you migrate from localStorage to Supabase when you're ready.

## 📋 Prerequisites

1. Create a Supabase project at https://supabase.com
2. Get your project URL and anon key
3. Install Supabase client: `npm install @supabase/supabase-js`

## 🗄️ Database Schema

Run these SQL commands in your Supabase SQL Editor:

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('student', 'faculty', 'super_admin')),
  department TEXT NOT NULL CHECK (department IN ('IT', 'CS', 'ECS', 'ETC', 'BM')),
  roll_number TEXT,
  semester INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Groups table
CREATE TABLE groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id TEXT UNIQUE NOT NULL,
  team_code TEXT UNIQUE NOT NULL,
  department TEXT NOT NULL,
  created_by UUID REFERENCES profiles(id),
  members UUID[] DEFAULT ARRAY[]::UUID[],
  is_full BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Mentor allocation forms table
CREATE TABLE mentor_allocation_forms (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  department TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_by UUID REFERENCES profiles(id),
  available_mentors UUID[] DEFAULT ARRAY[]::UUID[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Mentor preferences table
CREATE TABLE mentor_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID REFERENCES groups(id),
  form_id UUID REFERENCES mentor_allocation_forms(id),
  mentor_choices UUID[] NOT NULL,
  submitted_by UUID REFERENCES profiles(id),
  submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Mentor allocations table
CREATE TABLE mentor_allocations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID REFERENCES groups(id),
  mentor_id UUID REFERENCES profiles(id),
  form_id UUID REFERENCES mentor_allocation_forms(id),
  status TEXT NOT NULL CHECK (status IN ('pending', 'accepted', 'rejected')),
  preference_rank INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Group counters table (for serial numbers)
CREATE TABLE group_counters (
  department TEXT PRIMARY KEY,
  counter INTEGER DEFAULT 0
);

-- Insert initial counters
INSERT INTO group_counters (department, counter) VALUES
  ('IT', 0), ('CS', 0), ('ECS', 0), ('ETC', 0), ('BM', 0);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE mentor_allocation_forms ENABLE ROW LEVEL SECURITY;
ALTER TABLE mentor_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE mentor_allocations ENABLE ROW LEVEL SECURITY;

-- Note: Super Admins can also be mentors
-- The application includes both faculty and super_admin roles in mentor lists

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can insert their own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = user_id);

-- Groups policies
CREATE POLICY "Groups are viewable by department members"
  ON groups FOR SELECT
  USING (
    department IN (
      SELECT department FROM profiles WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Students can create groups"
  ON groups FOR INSERT
  WITH CHECK (
    created_by IN (
      SELECT id FROM profiles WHERE user_id = auth.uid() AND role = 'student'
    )
  );

CREATE POLICY "Group members can update group"
  ON groups FOR UPDATE
  USING (
    created_by IN (
      SELECT id FROM profiles WHERE user_id = auth.uid()
    )
  );

-- Mentor allocation forms policies
CREATE POLICY "Forms viewable by department"
  ON mentor_allocation_forms FOR SELECT
  USING (
    department IN (
      SELECT department FROM profiles WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Only super admin can create forms"
  ON mentor_allocation_forms FOR INSERT
  WITH CHECK (
    created_by IN (
      SELECT id FROM profiles WHERE user_id = auth.uid() AND role = 'super_admin'
    )
  );

-- Add similar policies for other tables...
```

## 🔧 Code Changes

### 1. Create Supabase Client

Create `lib/supabase.ts`:

```typescript
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

### 2. Update `lib/storage.ts`

Replace localStorage functions with Supabase queries. Example:

**Before (localStorage):**
```typescript
export const createProfile = (profileData: Omit<Profile, "id" | "createdAt">): Profile => {
  const profiles = JSON.parse(localStorage.getItem(KEYS.PROFILES) || "[]");
  const profile: Profile = {
    ...profileData,
    id: generateId(),
    createdAt: new Date().toISOString(),
  };
  profiles.push(profile);
  localStorage.setItem(KEYS.PROFILES, JSON.stringify(profiles));
  return profile;
};
```

**After (Supabase):**
```typescript
export const createProfile = async (
  profileData: Omit<Profile, "id" | "createdAt">
): Promise<Profile> => {
  const { data, error } = await supabase
    .from('profiles')
    .insert([profileData])
    .select()
    .single();
  
  if (error) throw error;
  return data;
};
```

### 3. Update Auth Context

Replace `getCurrentUser()` with Supabase Auth:

```typescript
import { supabase } from '@/lib/supabase';

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState(null);
  const [profile, setProfile] = useState(null);

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      if (session?.user) {
        loadProfile(session.user.id);
      }
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        setUser(session?.user ?? null);
        if (session?.user) {
          loadProfile(session.user.id);
        }
      }
    );

    return () => subscription.unsubscribe();
  }, []);

  const loadProfile = async (userId: string) => {
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .eq('user_id', userId)
      .single();
    setProfile(data);
  };

  // ... rest of context
}
```

### 4. Update Auth Pages

**Sign Up:**
```typescript
const { data, error } = await supabase.auth.signUp({
  email,
  password,
});
```

**Login:**
```typescript
const { data, error } = await supabase.auth.signInWithPassword({
  email,
  password,
});
```

**Logout:**
```typescript
await supabase.auth.signOut();
```

## 📝 Migration Checklist

- [ ] Create Supabase project
- [ ] Run database schema SQL
- [ ] Install Supabase client
- [ ] Create `.env.local` with credentials
- [ ] Update `lib/storage.ts` functions to async
- [ ] Update all components to handle async storage
- [ ] Replace auth functions with Supabase Auth
- [ ] Test all features
- [ ] Set up Row Level Security policies
- [ ] Deploy to production

## 🔒 Security Considerations

1. **Row Level Security**: Enable RLS on all tables
2. **API Keys**: Never commit `.env.local` to git
3. **Policies**: Restrict access by role and department
4. **Validation**: Add database constraints and triggers

## 🚀 Benefits After Migration

- ✅ Real-time updates across users
- ✅ Persistent data storage
- ✅ Built-in authentication
- ✅ Automatic backups
- ✅ Scalable infrastructure
- ✅ File storage capability
- ✅ Real-time subscriptions

## 📚 Resources

- [Supabase Docs](https://supabase.com/docs)
- [Next.js + Supabase Guide](https://supabase.com/docs/guides/getting-started/quickstarts/nextjs)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

---

Need help with migration? Check the Supabase documentation or community!


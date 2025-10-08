"use client";

import React, { createContext, useContext, useEffect, useState } from "react";
import { User, Profile } from "@/types";
import { getCurrentUser, getProfileByUserId } from "@/lib/storage";

interface AuthContextType {
  user: User | null;
  profile: Profile | null;
  loading: boolean;
  refreshAuth: () => void;
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  profile: null,
  loading: true,
  refreshAuth: () => {},
});

export const useAuth = () => useContext(AuthContext);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);

  const refreshAuth = () => {
    const currentUser = getCurrentUser();
    setUser(currentUser);

    if (currentUser) {
      const userProfile = getProfileByUserId(currentUser.id);
      setProfile(userProfile);
    } else {
      setProfile(null);
    }

    setLoading(false);
  };

  useEffect(() => {
    refreshAuth();
  }, []);

  return (
    <AuthContext.Provider value={{ user, profile, loading, refreshAuth }}>
      {children}
    </AuthContext.Provider>
  );
}


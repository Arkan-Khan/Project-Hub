"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Users, Check, X } from "lucide-react";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { useAuth } from "@/lib/auth-context";
import { useToast } from "@/components/ui/toast";
import { mentorAllocationApi } from "@/lib/api";
import { MentorAllocation, Profile, Group } from "@/types";

interface AllocationWithDetails extends MentorAllocation {
  group?: Group;
  members?: Profile[];
}

export default function FacultyDashboard() {
  const router = useRouter();
  const { user, profile } = useAuth();
  const { showToast } = useToast();

  const [allocations, setAllocations] = useState<AllocationWithDetails[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!user || !profile) {
      router.push("/auth/login");
      return;
    }

    if (profile.role !== "faculty" && profile.role !== "super_admin") {
      router.push("/dashboard");
      return;
    }

    loadAllocations();
  }, [user, profile, router]);

  const loadAllocations = async () => {
    if (!profile) return;

    try {
      const mentorAllocations = await mentorAllocationApi.getForMentor();

      // Sort: pending first, then by preference rank
      mentorAllocations.sort((a, b) => {
        if (a.status === "pending" && b.status !== "pending") return -1;
        if (a.status !== "pending" && b.status === "pending") return 1;
        return a.preferenceRank - b.preferenceRank;
      });

      setAllocations(mentorAllocations);
    } catch (error) {
      console.error("Error loading allocations:", error);
      showToast("Failed to load allocations", "error");
    }
  };

  const handleAccept = async (allocationId: string) => {
    setLoading(true);
    try {
      await mentorAllocationApi.accept(allocationId);
      showToast("Team accepted successfully!", "success");
      await loadAllocations();
    } catch (error: any) {
      showToast(error.message || "Failed to accept team", "error");
    } finally {
      setLoading(false);
    }
  };

  const handleReject = async (allocationId: string) => {
    setLoading(true);
    try {
      await mentorAllocationApi.reject(allocationId);
      showToast("Team rejected", "info");
      await loadAllocations();
    } catch (error: any) {
      showToast(error.message || "Failed to reject team", "error");
    } finally {
      setLoading(false);
    }
  };

  const getPreferenceLabel = (rank: number) => {
    return ["1st Choice", "2nd Choice", "3rd Choice"][rank - 1] || `${rank}th Choice`;
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "accepted":
        return "bg-green-100 text-green-800 border-green-200";
      case "rejected":
        return "bg-red-100 text-red-800 border-red-200";
      default:
        return "bg-amber-100 text-amber-800 border-amber-200";
    }
  };

  const acceptedTeams = allocations.filter((a) => a.status === "accepted");
  const pendingRequests = allocations.filter((a) => a.status === "pending");
  const rejectedRequests = allocations.filter((a) => a.status === "rejected");

  return (
    <DashboardLayout title="Faculty Dashboard">
      <div className="max-w-4xl mx-auto space-y-6">
        {/* Navigation for Super Admins */}
        {profile?.role === "super_admin" && (
          <div className="flex justify-end">
            <Button
              variant="outline"
              onClick={() => router.push("/dashboard/admin")}
              size="sm"
            >
              Back to Admin Dashboard
            </Button>
          </div>
        )}

        {/* Summary Stats */}
        <div className="grid md:grid-cols-3 gap-4">
          <Card>
            <CardContent className="pt-6">
              <div className="text-center">
                <p className="text-3xl font-bold text-green-600">
                  {acceptedTeams.length}
                </p>
                <p className="text-sm text-gray-600 mt-1">My Teams</p>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <div className="text-center">
                <p className="text-3xl font-bold text-amber-600">
                  {pendingRequests.length}
                </p>
                <p className="text-sm text-gray-600 mt-1">Pending Requests</p>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <div className="text-center">
                <p className="text-3xl font-bold text-gray-900">
                  {allocations.length}
                </p>
                <p className="text-sm text-gray-600 mt-1">Total Requests</p>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* My Teams Section */}
        {acceptedTeams.length > 0 && (
          <Card>
            <CardHeader>
              <CardTitle>My Teams</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {acceptedTeams.map((allocation) => (
                  <div
                    key={allocation.id}
                    className="border-2 border-green-200 bg-green-50 rounded-lg p-4"
                  >
                    <div className="flex items-start justify-between mb-3">
                      <div>
                        <h3 className="font-semibold text-lg">
                          {allocation.group?.groupId || "Unknown Group"}
                        </h3>
                        <p className="text-sm text-gray-600">
                          Team Code: {allocation.group?.teamCode}
                        </p>
                      </div>
                      <div className="text-right">
                        <span className="inline-block px-3 py-1 rounded-full text-xs font-medium border bg-green-100 text-green-800 border-green-200">
                          <Check className="h-3 w-3 inline mr-1" />
                          Accepted
                        </span>
                        <p className="text-xs text-gray-600 mt-1">
                          {getPreferenceLabel(allocation.preferenceRank)}
                        </p>
                      </div>
                    </div>

                    <div>
                      <p className="text-sm font-medium text-gray-700 mb-2">
                        Team Members:
                      </p>
                      <div className="space-y-1">
                        {allocation.members?.map((member) => (
                          <div key={member.id} className="text-sm text-gray-600">
                            • {member.name} ({member.rollNumber})
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        )}

        {/* Pending Requests Section */}
        <Card>
          <CardHeader>
            <CardTitle>
              Pending Requests {pendingRequests.length > 0 && `(${pendingRequests.length})`}
            </CardTitle>
          </CardHeader>
          <CardContent>
            {pendingRequests.length === 0 ? (
              <div className="text-center py-8 text-gray-600">
                <Users className="h-12 w-12 mx-auto mb-3 text-gray-400" />
                <p>
                  {allocations.length === 0
                    ? "No teams have selected you as a mentor yet"
                    : "No pending requests"}
                </p>
              </div>
            ) : (
              <div className="space-y-4">
                {pendingRequests.map((allocation) => (
                  <div
                    key={allocation.id}
                    className="border border-gray-200 rounded-lg p-4"
                  >
                    <div className="flex items-start justify-between mb-3">
                      <div>
                        <h3 className="font-semibold text-lg">
                          {allocation.group?.groupId || "Unknown Group"}
                        </h3>
                        <p className="text-sm text-gray-600">
                          Team Code: {allocation.group?.teamCode}
                        </p>
                      </div>
                      <div className="text-right">
                        <span
                          className={`inline-block px-3 py-1 rounded-full text-xs font-medium border ${getStatusColor(
                            allocation.status
                          )}`}
                        >
                          {allocation.status.charAt(0).toUpperCase() +
                            allocation.status.slice(1)}
                        </span>
                        <p className="text-xs text-gray-600 mt-1">
                          {getPreferenceLabel(allocation.preferenceRank)}
                        </p>
                      </div>
                    </div>

                    <div className="mb-4">
                      <p className="text-sm font-medium text-gray-700 mb-2">
                        Team Members:
                      </p>
                      <div className="space-y-1">
                        {allocation.members?.map((member) => (
                          <div key={member.id} className="text-sm text-gray-600">
                            • {member.name} ({member.rollNumber})
                          </div>
                        ))}
                      </div>
                    </div>

                    <div className="flex gap-2">
                      <Button
                        onClick={() => handleAccept(allocation.id)}
                        disabled={loading}
                        size="sm"
                        className="flex-1"
                      >
                        <Check className="h-4 w-4 mr-2" />
                        Accept Team
                      </Button>
                      <Button
                        onClick={() => handleReject(allocation.id)}
                        disabled={loading}
                        variant="outline"
                        size="sm"
                        className="flex-1"
                      >
                        <X className="h-4 w-4 mr-2" />
                        Reject
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}


"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Users, Plus, UserPlus, FileText } from "lucide-react";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useAuth } from "@/lib/auth-context";
import { useToast } from "@/components/ui/toast";
import {
  createGroup,
  getGroupByMemberId,
  getGroupByTeamCode,
  joinGroup,
  getProfileById,
  getActiveMentorForm,
  getMentorPreferenceByGroup,
  getAllocationsForGroup,
} from "@/lib/storage";
import { Group, Profile } from "@/types";

export default function StudentDashboard() {
  const router = useRouter();
  const { user, profile } = useAuth();
  const { showToast } = useToast();

  const [group, setGroup] = useState<Group | null>(null);
  const [members, setMembers] = useState<Profile[]>([]);
  const [teamCodeInput, setTeamCodeInput] = useState("");
  const [showJoinForm, setShowJoinForm] = useState(false);
  const [loading, setLoading] = useState(false);
  const [mentorFormActive, setMentorFormActive] = useState(false);
  const [hasSubmittedPreferences, setHasSubmittedPreferences] = useState(false);
  const [mentorStatus, setMentorStatus] = useState<{
    mentorName: string;
    status: string;
  } | null>(null);

  useEffect(() => {
    if (!user || !profile) {
      router.push("/auth/login");
      return;
    }

    if (profile.role !== "student") {
      router.push("/dashboard");
      return;
    }

    loadGroupData();
  }, [user, profile, router]);

  const loadGroupData = () => {
    if (!profile) return;

    const userGroup = getGroupByMemberId(profile.id);
    setGroup(userGroup);

    if (userGroup) {
      const groupMembers = userGroup.members
        .map((id) => getProfileById(id))
        .filter(Boolean) as Profile[];
      setMembers(groupMembers);

      // Check if mentor form is active
      const activeForm = getActiveMentorForm(profile.department);
      setMentorFormActive(!!activeForm);

      // Check if preferences submitted
      const preferences = getMentorPreferenceByGroup(userGroup.id);
      setHasSubmittedPreferences(!!preferences);

      // Check mentor allocation status
      const allocations = getAllocationsForGroup(userGroup.id);
      const acceptedAllocation = allocations.find((a) => a.status === "accepted");
      if (acceptedAllocation) {
        const mentor = getProfileById(acceptedAllocation.mentorId);
        setMentorStatus({
          mentorName: mentor?.name || "Unknown",
          status: "Accepted",
        });
      } else if (allocations.length > 0) {
        setMentorStatus({
          mentorName: "",
          status: "Pending",
        });
      }
    }
  };

  const handleCreateGroup = async () => {
    if (!profile) return;

    setLoading(true);
    try {
      const newGroup = createGroup(profile.id, profile.department);
      setGroup(newGroup);
      setMembers([profile]);
      showToast("Group created successfully!", "success");
      loadGroupData();
    } catch (error: any) {
      showToast(error.message || "Failed to create group", "error");
    } finally {
      setLoading(false);
    }
  };

  const handleJoinGroup = async () => {
    if (!profile) return;

    setLoading(true);
    try {
      const targetGroup = getGroupByTeamCode(teamCodeInput);

      if (!targetGroup) {
        showToast("Group not found", "error");
        return;
      }

      if (targetGroup.department !== profile.department) {
        showToast("Can only join groups from your department", "error");
        return;
      }

      joinGroup(teamCodeInput, profile.id);
      showToast("Joined group successfully!", "success");
      setShowJoinForm(false);
      setTeamCodeInput("");
      loadGroupData();
    } catch (error: any) {
      showToast(error.message || "Failed to join group", "error");
    } finally {
      setLoading(false);
    }
  };

  const isLeader = group && profile && group.createdBy === profile.id;

  return (
    <DashboardLayout title="Student Dashboard">
      <div className="max-w-4xl mx-auto space-y-6">
        {!group ? (
          <>
            <Card>
              <CardHeader>
                <CardTitle>Create or Join a Group</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div>
                  <Button
                    onClick={handleCreateGroup}
                    disabled={loading}
                    className="w-full"
                  >
                    <Plus className="h-4 w-4 mr-2" />
                    Create New Group
                  </Button>
                  <p className="text-sm text-gray-600 mt-2 text-center">
                    Start a new project group and invite your teammates
                  </p>
                </div>

                <div className="relative">
                  <div className="absolute inset-0 flex items-center">
                    <span className="w-full border-t" />
                  </div>
                  <div className="relative flex justify-center text-xs uppercase">
                    <span className="bg-white px-2 text-gray-500">Or</span>
                  </div>
                </div>

                <div>
                  {!showJoinForm ? (
                    <Button
                      onClick={() => setShowJoinForm(true)}
                      variant="outline"
                      className="w-full"
                    >
                      <UserPlus className="h-4 w-4 mr-2" />
                      Join Existing Group
                    </Button>
                  ) : (
                    <div className="space-y-3">
                      <Input
                        placeholder="Enter Team Code (e.g., A7DXQ)"
                        value={teamCodeInput}
                        onChange={(e) => setTeamCodeInput(e.target.value.toUpperCase())}
                        maxLength={5}
                      />
                      <div className="flex gap-2">
                        <Button
                          onClick={handleJoinGroup}
                          disabled={loading || !teamCodeInput}
                          className="flex-1"
                        >
                          Join Group
                        </Button>
                        <Button
                          onClick={() => {
                            setShowJoinForm(false);
                            setTeamCodeInput("");
                          }}
                          variant="outline"
                        >
                          Cancel
                        </Button>
                      </div>
                    </div>
                  )}
                  <p className="text-sm text-gray-600 mt-2 text-center">
                    Ask your team leader for the team code
                  </p>
                </div>
              </CardContent>
            </Card>
          </>
        ) : (
          <>
            <Card>
              <CardHeader>
                <CardTitle>Your Group</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-gray-600">Group ID</p>
                    <p className="text-lg font-semibold">{group.groupId}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Team Code</p>
                    <p className="text-lg font-semibold text-accent">
                      {group.teamCode}
                    </p>
                  </div>
                </div>

                <div>
                  <p className="text-sm text-gray-600 mb-2">
                    Team Members ({members.length}/3)
                  </p>
                  <div className="space-y-2">
                    {members.map((member) => (
                      <div
                        key={member.id}
                        className="flex items-center justify-between p-3 border border-gray-200 rounded-md"
                      >
                        <div>
                          <p className="font-medium">{member.name}</p>
                          <p className="text-sm text-gray-600">{member.email}</p>
                        </div>
                        {member.id === group.createdBy && (
                          <span className="px-2 py-1 bg-accent/20 text-accent text-xs font-medium rounded">
                            Leader
                          </span>
                        )}
                      </div>
                    ))}
                  </div>
                </div>

                {!group.isFull && (
                  <div className="p-3 bg-blue-50 border border-blue-200 rounded-md">
                    <p className="text-sm text-blue-900">
                      <strong>Share Team Code:</strong> {group.teamCode} with your
                      teammates to let them join
                    </p>
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Mentor Allocation Section */}
            {mentorFormActive && (
              <Card>
                <CardHeader>
                  <CardTitle>Mentor Allocation</CardTitle>
                </CardHeader>
                <CardContent>
                  {hasSubmittedPreferences ? (
                    <div className="space-y-3">
                      <div className="p-4 bg-green-50 border border-green-200 rounded-md">
                        <p className="text-green-900 font-medium">
                          ✓ Preferences Submitted
                        </p>
                      </div>
                      {mentorStatus && (
                        <div className="p-4 border border-gray-200 rounded-md">
                          <p className="text-sm text-gray-600">Status</p>
                          <p className="text-lg font-semibold">
                            {mentorStatus.status}
                          </p>
                          {mentorStatus.mentorName && (
                            <>
                              <p className="text-sm text-gray-600 mt-2">
                                Assigned Mentor
                              </p>
                              <p className="font-medium">
                                {mentorStatus.mentorName}
                              </p>
                            </>
                          )}
                        </div>
                      )}
                    </div>
                  ) : isLeader ? (
                    <div>
                      <p className="text-sm text-gray-600 mb-4">
                        The Mentor Allocation Form is now active. As the group
                        leader, you can submit your team's mentor preferences.
                      </p>
                      <Button
                        onClick={() =>
                          router.push("/dashboard/student/mentor-preferences")
                        }
                      >
                        <FileText className="h-4 w-4 mr-2" />
                        Fill Mentor Allocation Form
                      </Button>
                    </div>
                  ) : (
                    <div className="p-4 bg-amber-50 border border-amber-200 rounded-md">
                      <p className="text-amber-900">
                        Only the group leader can submit mentor preferences. Please
                        wait for your leader to complete the form.
                      </p>
                    </div>
                  )}
                </CardContent>
              </Card>
            )}
          </>
        )}
      </div>
    </DashboardLayout>
  );
}


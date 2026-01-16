"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { FileText, Users, UserCheck, ClipboardList, Play, CheckCircle } from "lucide-react";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { useAuth } from "@/lib/auth-context";
import { useToast } from "@/components/ui/toast";
import { 
  mentorFormApi, 
  profileApi, 
  groupApi 
  getReviewRolloutsByDepartment,
  rolloutReview,
  getTopicsByGroup,
  getReviewSession,
} from "@/lib/api";
import { MentorAllocationForm, Profile, ReviewRollout, ReviewType } from "@/types";

export default function AdminDashboard() {
  const router = useRouter();
  const { user, profile } = useAuth();
  const { showToast } = useToast();

  const [activeForm, setActiveForm] = useState<MentorAllocationForm | null>(null);
  const [facultyList, setFacultyList] = useState<Profile[]>([]);
  const [selectedMentors, setSelectedMentors] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [groups, setGroups] = useState<any[]>([]);
  const [reviewRollouts, setReviewRollouts] = useState<ReviewRollout[]>([]);

  useEffect(() => {
    if (!user || !profile) {
      router.push("/auth/login");
      return;
    }

    if (profile.role !== "super_admin") {
      router.push("/dashboard");
      return;
    }

    loadData();
  }, [user, profile, router]);

  const loadData = async () => {
    if (!profile) return;

    try {
      // Load active form
      const form = await mentorFormApi.getActiveByDepartment(profile.department);
      setActiveForm(form);

      // Load faculty list
      const faculty = await profileApi.getFacultyByDepartment(profile.department);
      setFacultyList(faculty);

    if (form) {
      setSelectedMentors(form.availableMentors);
    }

    const deptGroups = getGroupsByDepartment(profile.department);
    const groupsWithDetails = deptGroups.map((group) => {
      const leader = getProfileById(group.createdBy);
      const preferences = JSON.parse(
        localStorage.getItem("projecthub_mentor_preferences") || "[]"
      ).find((p: any) => p.groupId === group.id);

      const allocations = JSON.parse(
        localStorage.getItem("projecthub_mentor_allocations") || "[]"
      ).filter((a: any) => a.groupId === group.id);

      const acceptedAllocation = allocations.find((a: any) => a.status === "accepted");

      // Get topic approval status
      const topics = getTopicsByGroup(group.id);
      const approvedTopic = topics.find((t) => t.status === "approved");

      // Get review statuses
      const r1 = getReviewSession(group.id, "review_1");
      const r2 = getReviewSession(group.id, "review_2");
      const fr = getReviewSession(group.id, "final_review");

      return {
        ...group,
        leaderName: leader?.name,
        hasSubmittedPreferences: !!preferences,
        mentorAssigned: acceptedAllocation
          ? getProfileById(acceptedAllocation.mentorId)?.name
          : null,
        topicApproved: !!approvedTopic,
        topicTitle: approvedTopic?.title,
        review1Status: r1?.status,
        review1Progress: r1?.progressPercentage,
        review2Status: r2?.status,
        review2Progress: r2?.progressPercentage,
        finalReviewStatus: fr?.status,
        finalReviewProgress: fr?.progressPercentage,
      };
    });

    setGroups(groupsWithDetails);

    // Load review rollouts
    const rollouts = getReviewRolloutsByDepartment(profile.department);
    setReviewRollouts(rollouts);
  };

  const handleToggleMentor = (mentorId: string) => {
    if (selectedMentors.includes(mentorId)) {
      setSelectedMentors(selectedMentors.filter((id) => id !== mentorId));
    } else {
      setSelectedMentors([...selectedMentors, mentorId]);
    }
  };

  const handleRollOutForm = async () => {
    if (!profile) return;

    if (selectedMentors.length === 0) {
      showToast("Please select at least one mentor", "error");
      return;
    }

    setLoading(true);
    try {
      await mentorFormApi.create({ availableMentorIds: selectedMentors });
      showToast("Mentor Allocation Form rolled out successfully!", "success");
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to roll out form", "error");
    } finally {
      setLoading(false);
    }
  };

  const handleRolloutReview = async (reviewType: ReviewType) => {
    if (!profile) return;

    setLoading(true);
    try {
      rolloutReview(profile.department, reviewType, profile.id);
      const reviewName = reviewType === "review_1" 
        ? "Review 1" 
        : reviewType === "review_2" 
        ? "Review 2" 
        : "Final Review";
      showToast(`${reviewName} rolled out successfully!`, "success");
      loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to roll out review", "error");
    } finally {
      setLoading(false);
    }
  };

  const isReviewRolledOut = (reviewType: ReviewType) => {
    return reviewRollouts.some((r) => r.reviewType === reviewType && r.isActive);
  };

  return (
    <DashboardLayout title="Super Admin Dashboard">
      <div className="max-w-6xl mx-auto space-y-6">
        {/* Navigation to Faculty View */}
        <div className="flex justify-end">
          <Button
            variant="outline"
            onClick={() => router.push("/dashboard/faculty")}
            size="sm"
          >
            <Users className="h-4 w-4 mr-2" />
            View My Mentor Requests
          </Button>
        </div>
        {/* Stats */}
        <div className="grid md:grid-cols-3 gap-4">
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-4">
                <Users className="h-8 w-8 text-primary" />
                <div>
                  <p className="text-2xl font-bold text-gray-900">{groups.length}</p>
                  <p className="text-sm text-gray-600">Total Groups</p>
                </div>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-4">
                <UserCheck className="h-8 w-8 text-primary" />
                <div>
                  <p className="text-2xl font-bold text-gray-900">
                    {facultyList.length}
                  </p>
                  <p className="text-sm text-gray-600">Faculty Members</p>
                </div>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-4">
                <FileText className="h-8 w-8 text-primary" />
                <div>
                  <p className="text-2xl font-bold text-gray-900">
                    {groups.filter((g) => g.hasSubmittedPreferences).length}
                  </p>
                  <p className="text-sm text-gray-600">Submissions</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Mentor Allocation Form */}
        <Card>
          <CardHeader>
            <CardTitle>Mentor Allocation Form</CardTitle>
          </CardHeader>
          <CardContent>
            {activeForm ? (
              <div className="p-4 bg-green-50 border border-green-200 rounded-md">
                <p className="font-medium text-green-900 mb-2">
                  ✓ Form is Currently Active
                </p>
                <p className="text-sm text-green-800">
                  {selectedMentors.length} mentors available for selection
                </p>
              </div>
            ) : (
              <div className="space-y-4">
                <p className="text-sm text-gray-600">
                  Roll out the mentor allocation form for {profile?.department}{" "}
                  department. Select faculty members and coordinators to be available as mentors.
                </p>

                {facultyList.length === 0 ? (
                  <div className="p-4 bg-amber-50 border border-amber-200 rounded-md">
                    <p className="text-amber-900">
                      No mentors found in your department. Faculty must
                      register first.
                    </p>
                  </div>
                ) : (
                  <>
                    <div className="space-y-2 max-h-64 overflow-y-auto border border-gray-200 rounded-md p-3">
                      {facultyList.map((faculty) => (
                        <label
                          key={faculty.id}
                          className="flex items-center gap-3 p-2 hover:bg-gray-50 rounded cursor-pointer"
                        >
                          <input
                            type="checkbox"
                            checked={selectedMentors.includes(faculty.id)}
                            onChange={() => handleToggleMentor(faculty.id)}
                            className="h-4 w-4 text-primary"
                          />
                          <div className="flex-1">
                            <div className="flex items-center gap-2">
                              <p className="font-medium">{faculty.name}</p>
                              {faculty.role === "super_admin" && (
                                <span className="px-2 py-0.5 bg-accent/20 text-accent text-xs font-medium rounded">
                                  Coordinator
                                </span>
                              )}
                            </div>
                            <p className="text-sm text-gray-600">{faculty.email}</p>
                          </div>
                        </label>
                      ))}
                    </div>

                    <Button
                      onClick={handleRollOutForm}
                      disabled={loading || selectedMentors.length === 0}
                      className="w-full"
                    >
                      <FileText className="h-4 w-4 mr-2" />
                      Roll Out Mentor Allocation Form
                    </Button>
                  </>
                )}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Review Rollout Card */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <ClipboardList className="h-5 w-5" />
              Review Rollout
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-gray-600 mb-4">
              Activate review phases for teams in your department. Teams can submit progress once each review is rolled out.
            </p>

            <div className="grid md:grid-cols-3 gap-4">
              {/* Review 1 */}
              <div className={`border rounded-lg p-4 ${isReviewRolledOut("review_1") ? "border-green-200 bg-green-50" : "border-gray-200"}`}>
                <div className="flex items-center justify-between mb-2">
                  <h4 className="font-medium">Review 1</h4>
                  {isReviewRolledOut("review_1") ? (
                    <Badge variant="success">
                      <CheckCircle className="h-3 w-3 mr-1" />
                      Active
                    </Badge>
                  ) : (
                    <Badge variant="outline">Not Started</Badge>
                  )}
                </div>
                <p className="text-xs text-gray-600 mb-3">
                  Initial progress check after 2-3 weeks
                </p>
                {!isReviewRolledOut("review_1") && (
                  <Button
                    size="sm"
                    onClick={() => handleRolloutReview("review_1")}
                    disabled={loading}
                    className="w-full gap-1"
                  >
                    <Play className="h-4 w-4" />
                    Activate
                  </Button>
                )}
                {isReviewRolledOut("review_1") && (
                  <p className="text-xs text-green-700">
                    {groups.filter(g => g.review1Status).length}/{groups.filter(g => g.mentorAssigned).length} teams submitted
                  </p>
                )}
              </div>

              {/* Review 2 */}
              <div className={`border rounded-lg p-4 ${isReviewRolledOut("review_2") ? "border-green-200 bg-green-50" : "border-gray-200"}`}>
                <div className="flex items-center justify-between mb-2">
                  <h4 className="font-medium">Review 2</h4>
                  {isReviewRolledOut("review_2") ? (
                    <Badge variant="success">
                      <CheckCircle className="h-3 w-3 mr-1" />
                      Active
                    </Badge>
                  ) : (
                    <Badge variant="outline">Not Started</Badge>
                  )}
                </div>
                <p className="text-xs text-gray-600 mb-3">
                  90% completion expected
                </p>
                {!isReviewRolledOut("review_2") && (
                  <Button
                    size="sm"
                    onClick={() => handleRolloutReview("review_2")}
                    disabled={loading || !isReviewRolledOut("review_1")}
                    className="w-full gap-1"
                  >
                    <Play className="h-4 w-4" />
                    Activate
                  </Button>
                )}
                {isReviewRolledOut("review_2") && (
                  <p className="text-xs text-green-700">
                    {groups.filter(g => g.review2Status).length}/{groups.filter(g => g.mentorAssigned).length} teams submitted
                  </p>
                )}
              </div>

              {/* Final Review */}
              <div className={`border rounded-lg p-4 ${isReviewRolledOut("final_review") ? "border-green-200 bg-green-50" : "border-gray-200"}`}>
                <div className="flex items-center justify-between mb-2">
                  <h4 className="font-medium">Final Review</h4>
                  {isReviewRolledOut("final_review") ? (
                    <Badge variant="success">
                      <CheckCircle className="h-3 w-3 mr-1" />
                      Active
                    </Badge>
                  ) : (
                    <Badge variant="outline">Not Started</Badge>
                  )}
                </div>
                <p className="text-xs text-gray-600 mb-3">
                  Project completion & submission
                </p>
                {!isReviewRolledOut("final_review") && (
                  <Button
                    size="sm"
                    onClick={() => handleRolloutReview("final_review")}
                    disabled={loading || !isReviewRolledOut("review_2")}
                    className="w-full gap-1"
                  >
                    <Play className="h-4 w-4" />
                    Activate
                  </Button>
                )}
                {isReviewRolledOut("final_review") && (
                  <p className="text-xs text-green-700">
                    {groups.filter(g => g.finalReviewStatus).length}/{groups.filter(g => g.mentorAssigned).length} teams submitted
                  </p>
                )}
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Groups Overview */}
        <Card>
          <CardHeader>
            <CardTitle>Groups Overview</CardTitle>
          </CardHeader>
          <CardContent>
            {groups.length === 0 ? (
              <p className="text-center py-8 text-gray-600">
                No groups created yet
              </p>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b border-gray-200 text-left">
                      <th className="pb-2 text-sm font-medium text-gray-700">
                        Group ID
                      </th>
                      <th className="pb-2 text-sm font-medium text-gray-700">
                        Team Code
                      </th>
                      <th className="pb-2 text-sm font-medium text-gray-700">
                        Leader
                      </th>
                      <th className="pb-2 text-sm font-medium text-gray-700">
                        Mentor
                      </th>
                      <th className="pb-2 text-sm font-medium text-gray-700">
                        Topic
                      </th>
                      <th className="pb-2 text-sm font-medium text-gray-700 text-center">
                        R1
                      </th>
                      <th className="pb-2 text-sm font-medium text-gray-700 text-center">
                        R2
                      </th>
                      <th className="pb-2 text-sm font-medium text-gray-700 text-center">
                        Final
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {groups.map((group) => (
                      <tr key={group.id} className="border-b border-gray-100">
                        <td className="py-3 text-sm">{group.groupId}</td>
                        <td className="py-3 text-sm font-mono">{group.teamCode}</td>
                        <td className="py-3 text-sm">{group.leaderName}</td>
                        <td className="py-3 text-sm">
                          {group.mentorAssigned || (
                            <span className="text-gray-400">—</span>
                          )}
                        </td>
                        <td className="py-3 text-sm">
                          {group.topicApproved ? (
                            <span className="text-green-600 truncate max-w-[150px] block" title={group.topicTitle}>
                              ✓ {group.topicTitle?.substring(0, 20)}...
                            </span>
                          ) : group.mentorAssigned ? (
                            <span className="text-amber-600">Pending</span>
                          ) : (
                            <span className="text-gray-400">—</span>
                          )}
                        </td>
                        <td className="py-3 text-sm text-center">
                          {group.review1Status === "completed" ? (
                            <Badge variant="success" className="text-xs">✓</Badge>
                          ) : group.review1Progress ? (
                            <Badge variant="warning" className="text-xs">{group.review1Progress}%</Badge>
                          ) : (
                            <span className="text-gray-400">—</span>
                          )}
                        </td>
                        <td className="py-3 text-sm text-center">
                          {group.review2Status === "completed" ? (
                            <Badge variant="success" className="text-xs">✓</Badge>
                          ) : group.review2Progress ? (
                            <Badge variant="warning" className="text-xs">{group.review2Progress}%</Badge>
                          ) : (
                            <span className="text-gray-400">—</span>
                          )}
                        </td>
                        <td className="py-3 text-sm text-center">
                          {group.finalReviewStatus === "completed" ? (
                            <Badge variant="success" className="text-xs">✓</Badge>
                          ) : group.finalReviewProgress ? (
                            <Badge variant="warning" className="text-xs">{group.finalReviewProgress}%</Badge>
                          ) : (
                            <span className="text-gray-400">—</span>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}


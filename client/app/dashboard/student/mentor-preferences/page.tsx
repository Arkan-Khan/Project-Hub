"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { ArrowLeft, Check } from "lucide-react";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { useAuth } from "@/lib/auth-context";
import { useToast } from "@/components/ui/toast";
import {
  getGroupByMemberId,
  getActiveMentorForm,
  submitMentorPreferences,
  getProfileById,
  getMentorPreferenceByGroup,
} from "@/lib/storage";
import { Profile } from "@/types";

export default function MentorPreferencesPage() {
  const router = useRouter();
  const { user, profile } = useAuth();
  const { showToast } = useToast();

  const [availableMentors, setAvailableMentors] = useState<Profile[]>([]);
  const [selectedMentors, setSelectedMentors] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [groupId, setGroupId] = useState<string>("");

  useEffect(() => {
    if (!user || !profile) {
      router.push("/auth/login");
      return;
    }

    if (profile.role !== "student") {
      router.push("/dashboard");
      return;
    }

    loadMentorForm();
  }, [user, profile, router]);

  const loadMentorForm = () => {
    if (!profile) return;

    const group = getGroupByMemberId(profile.id);
    if (!group) {
      showToast("You are not part of any group", "error");
      router.push("/dashboard/student");
      return;
    }

    setGroupId(group.id);

    // Check if user is leader
    if (group.createdBy !== profile.id) {
      showToast("Only the group leader can submit preferences", "error");
      router.push("/dashboard/student");
      return;
    }

    // Check if already submitted
    const existingPreferences = getMentorPreferenceByGroup(group.id);
    if (existingPreferences) {
      showToast("Preferences already submitted", "info");
      router.push("/dashboard/student");
      return;
    }

    // Get active form
    const activeForm = getActiveMentorForm(profile.department);
    if (!activeForm) {
      showToast("No active mentor allocation form", "error");
      router.push("/dashboard/student");
      return;
    }

    // Load available mentors
    const mentors = activeForm.availableMentors
      .map((id) => getProfileById(id))
      .filter(Boolean) as Profile[];

    setAvailableMentors(mentors);
  };

  const handleSelectMentor = (mentorId: string) => {
    if (selectedMentors.includes(mentorId)) {
      setSelectedMentors(selectedMentors.filter((id) => id !== mentorId));
    } else {
      if (selectedMentors.length >= 3) {
        showToast("You can select maximum 3 mentors", "error");
        return;
      }
      setSelectedMentors([...selectedMentors, mentorId]);
    }
  };

  const handleSubmit = async () => {
    if (selectedMentors.length !== 3) {
      showToast("Please select exactly 3 mentors", "error");
      return;
    }

    if (!profile || !groupId) return;

    setLoading(true);
    try {
      submitMentorPreferences(
        groupId,
        getActiveMentorForm(profile.department)!.id,
        selectedMentors as [string, string, string],
        profile.id
      );
      showToast("Preferences submitted successfully!", "success");
      router.push("/dashboard/student");
    } catch (error: any) {
      showToast(error.message || "Failed to submit preferences", "error");
    } finally {
      setLoading(false);
    }
  };

  const getPreferenceNumber = (mentorId: string) => {
    const index = selectedMentors.indexOf(mentorId);
    return index === -1 ? null : index + 1;
  };

  return (
    <DashboardLayout title="Mentor Preferences">
      <div className="max-w-4xl mx-auto space-y-6">
        <Button
          variant="ghost"
          onClick={() => router.push("/dashboard/student")}
          className="mb-4"
        >
          <ArrowLeft className="h-4 w-4 mr-2" />
          Back to Dashboard
        </Button>

        <Card>
          <CardHeader>
            <CardTitle>Select Your Mentor Preferences</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div className="p-4 bg-blue-50 border border-blue-200 rounded-md">
                <p className="text-sm text-blue-900">
                  <strong>Instructions:</strong> Select exactly 3 mentors in order of
                  preference. Click on a mentor to select them. Click again to
                  deselect.
                </p>
              </div>

              {/* Selection Status */}
              <div className="flex items-center justify-between p-3 bg-gray-50 rounded-md">
                <span className="text-sm font-medium">Selected:</span>
                <div className="flex gap-2">
                  {[1, 2, 3].map((num) => (
                    <div
                      key={num}
                      className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium ${
                        selectedMentors[num - 1]
                          ? "bg-primary text-white"
                          : "bg-gray-200 text-gray-400"
                      }`}
                    >
                      {num}
                    </div>
                  ))}
                </div>
              </div>

              {/* Available Mentors */}
              {availableMentors.length === 0 ? (
                <div className="text-center py-8 text-gray-600">
                  <p>No mentors available</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {availableMentors.map((mentor) => {
                    const preferenceNum = getPreferenceNumber(mentor.id);
                    const isSelected = preferenceNum !== null;

                    return (
                      <button
                        key={mentor.id}
                        onClick={() => handleSelectMentor(mentor.id)}
                        className={`w-full text-left p-4 border-2 rounded-lg transition-all ${
                          isSelected
                            ? "border-primary bg-primary/5"
                            : "border-gray-200 hover:border-gray-300"
                        }`}
                      >
                        <div className="flex items-center justify-between">
                          <div className="flex-1">
                            <div className="flex items-center gap-2">
                              <h3 className="font-semibold text-lg">{mentor.name}</h3>
                              {mentor.role === "super_admin" && (
                                <span className="px-2 py-0.5 bg-accent/20 text-accent text-xs font-medium rounded">
                                  Coordinator
                                </span>
                              )}
                            </div>
                            <p className="text-sm text-gray-600">{mentor.email}</p>
                            <p className="text-xs text-gray-500 mt-1">
                              {mentor.department} Department
                            </p>
                          </div>
                          {isSelected && (
                            <div className="flex items-center gap-2">
                              <span className="text-sm font-medium text-primary">
                                {preferenceNum === 1
                                  ? "1st Choice"
                                  : preferenceNum === 2
                                  ? "2nd Choice"
                                  : "3rd Choice"}
                              </span>
                              <div className="w-8 h-8 rounded-full bg-primary flex items-center justify-center">
                                <Check className="h-5 w-5 text-white" />
                              </div>
                            </div>
                          )}
                        </div>
                      </button>
                    );
                  })}
                </div>
              )}

              {/* Submit Button */}
              <div className="pt-4">
                <Button
                  onClick={handleSubmit}
                  disabled={loading || selectedMentors.length !== 3}
                  className="w-full"
                  size="lg"
                >
                  {loading
                    ? "Submitting..."
                    : `Submit Preferences ${
                        selectedMentors.length < 3
                          ? `(${selectedMentors.length}/3 selected)`
                          : ""
                      }`}
                </Button>
                {selectedMentors.length < 3 && (
                  <p className="text-center text-sm text-gray-600 mt-2">
                    Please select {3 - selectedMentors.length} more mentor
                    {3 - selectedMentors.length > 1 ? "s" : ""}
                  </p>
                )}
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}


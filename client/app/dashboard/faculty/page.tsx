"use client";

import { useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import { Users, Check, X, ClipboardList, Eye, RefreshCw } from "lucide-react";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { TopicApprovalSection } from "@/components/topic-approval-section";
import { ReviewSection } from "@/components/review-section";
import { useAuth } from "@/lib/auth-context";
import { useToast } from "@/components/ui/toast";
import { mentorAllocationApi   getTeamProgressForMentor,
  getTopicsByGroup,
  getTopicMessagesByGroup,
  createTopic,
  approveTopic,
  rejectTopic,
  requestTopicRevision,
  addTopicMessage,
  getReviewRollout,
  getReviewSession,
  getReviewMessagesByGroupAndType,
  createReviewSession,
  updateReviewSession,
  addReviewFeedback,
  markReviewComplete,
  addReviewMessage,
  getGroupById,
} from "@/lib/api";
import {
  MentorAllocation,
  Profile,
  Group,
  TeamProgress,
  ProjectTopic,
  TopicMessage,
  ReviewSession as ReviewSessionType,
  ReviewMessage,
  ReviewType,
} from "@/types";

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
  const [teamProgress, setTeamProgress] = useState<TeamProgress[]>([]);
  const [selectedTeam, setSelectedTeam] = useState<TeamProgress | null>(null);
  const [showTeamDialog, setShowTeamDialog] = useState(false);
  const [activeTab, setActiveTab] = useState("topic");

  // Selected team data
  const [selectedGroup, setSelectedGroup] = useState<Group | null>(null);
  const [topics, setTopics] = useState<ProjectTopic[]>([]);
  const [topicMessages, setTopicMessages] = useState<TopicMessage[]>([]);
  const [review1Session, setReview1Session] = useState<ReviewSessionType | null>(null);
  const [review2Session, setReview2Session] = useState<ReviewSessionType | null>(null);
  const [finalReviewSession, setFinalReviewSession] = useState<ReviewSessionType | null>(null);
  const [review1Messages, setReview1Messages] = useState<ReviewMessage[]>([]);
  const [review2Messages, setReview2Messages] = useState<ReviewMessage[]>([]);
  const [finalReviewMessages, setFinalReviewMessages] = useState<ReviewMessage[]>([]);
  const [review1RolledOut, setReview1RolledOut] = useState(false);
  const [review2RolledOut, setReview2RolledOut] = useState(false);
  const [finalReviewRolledOut, setFinalReviewRolledOut] = useState(false);

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

  const loadAllocations = async useCallback(() => {
    if (!profile) return;

    try {
      const mentorAllocations = await mentorAllocationApi.getForMentor();

      // Sort: pending first, then by preference rank
      mentorAllocations.sort((a, b) => {
        if (a.status === "pending" && b.status !== "pending") return -1;
        if (a.status !== "pending" && b.status === "pending") return 1;
        return a.preferenceRank - b.preferenceRank;
      });

    setAllocations(allocationsWithDetails);

    // Load team progress
    const progress = getTeamProgressForMentor(profile.id);
    setTeamProgress(progress);
  }, [profile]);

  const loadTeamData = useCallback((teamProg: TeamProgress) => {
    const group = getGroupById(teamProg.groupId);
    setSelectedGroup(group);

    if (group) {
      // Load topics
      setTopics(getTopicsByGroup(group.id));
      setTopicMessages(getTopicMessagesByGroup(group.id));

      // Load review rollouts
      setReview1RolledOut(!!getReviewRollout(group.department, "review_1"));
      setReview2RolledOut(!!getReviewRollout(group.department, "review_2"));
      setFinalReviewRolledOut(!!getReviewRollout(group.department, "final_review"));

      // Load review sessions
      setReview1Session(getReviewSession(group.id, "review_1"));
      setReview2Session(getReviewSession(group.id, "review_2"));
      setFinalReviewSession(getReviewSession(group.id, "final_review"));

      // Load review messages
      setReview1Messages(getReviewMessagesByGroupAndType(group.id, "review_1"));
      setReview2Messages(getReviewMessagesByGroupAndType(group.id, "review_2"));
      setFinalReviewMessages(getReviewMessagesByGroupAndType(group.id, "final_review"));
    }
  }, []);

  const openTeamDialog = (team: TeamProgress) => {
    setSelectedTeam(team);
    loadTeamData(team);
    setActiveTab("topic");
    setShowTeamDialog(true);
  };

  const refreshTeamData = () => {
    if (selectedTeam) {
      loadTeamData(selectedTeam);
      loadAllocations();
    }
    showToast("Data refreshed", "info");
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

  // Topic Approval Handlers
  const handleSubmitTopic = (title: string, description: string) => {
    if (!selectedGroup || !profile) return;
    try {
      createTopic(selectedGroup.id, title, description, profile.id);
      showToast("Topic submitted!", "success");
      if (selectedTeam) loadTeamData(selectedTeam);
    } catch (error: any) {
      showToast(error.message || "Failed to submit topic", "error");
    }
  };

  const handleApproveTopic = (topicId: string) => {
    if (!profile) return;
    try {
      approveTopic(topicId, profile.id);
      showToast("Topic approved!", "success");
      if (selectedTeam) loadTeamData(selectedTeam);
      loadAllocations();
    } catch (error: any) {
      showToast(error.message || "Failed to approve topic", "error");
    }
  };

  const handleRejectTopic = (topicId: string) => {
    if (!profile) return;
    try {
      rejectTopic(topicId, profile.id);
      showToast("Topic rejected", "info");
      if (selectedTeam) loadTeamData(selectedTeam);
    } catch (error: any) {
      showToast(error.message || "Failed to reject topic", "error");
    }
  };

  const handleRequestRevision = (topicId: string, feedback: string) => {
    if (!profile) return;
    try {
      requestTopicRevision(topicId, profile.id, feedback);
      showToast("Revision requested", "success");
      if (selectedTeam) loadTeamData(selectedTeam);
    } catch (error: any) {
      showToast(error.message || "Failed to request revision", "error");
    }
  };

  const handleSendTopicMessage = (content: string, links?: string[]) => {
    if (!selectedGroup || !profile) return;
    try {
      addTopicMessage(
        "general",
        selectedGroup.id,
        profile.id,
        profile.name,
        content,
        "faculty",
        links
      );
      if (selectedTeam) loadTeamData(selectedTeam);
    } catch (error: any) {
      showToast(error.message || "Failed to send message", "error");
    }
  };

  // Review Handlers
  const handleSubmitProgress = (
    reviewType: ReviewType,
    percentage: number,
    description: string
  ) => {
    if (!selectedGroup || !profile) return;
    try {
      createReviewSession(selectedGroup.id, reviewType, percentage, description, profile.id);
      showToast("Progress submitted!", "success");
      if (selectedTeam) loadTeamData(selectedTeam);
    } catch (error: any) {
      showToast(error.message || "Failed to submit progress", "error");
    }
  };

  const handleUpdateProgress = (
    reviewType: ReviewType,
    percentage: number,
    description: string
  ) => {
    if (!selectedGroup) return;
    const session = getReviewSession(selectedGroup.id, reviewType);
    if (!session) return;
    try {
      updateReviewSession(session.id, {
        progressPercentage: percentage,
        progressDescription: description,
      });
      showToast("Progress updated!", "success");
      if (selectedTeam) loadTeamData(selectedTeam);
    } catch (error: any) {
      showToast(error.message || "Failed to update progress", "error");
    }
  };

  const handleSubmitFeedback = (reviewType: ReviewType, feedback: string) => {
    if (!selectedGroup || !profile) return;
    const session = getReviewSession(selectedGroup.id, reviewType);
    if (!session) return;
    try {
      addReviewFeedback(session.id, feedback, profile.id);
      showToast("Feedback submitted!", "success");
      if (selectedTeam) loadTeamData(selectedTeam);
      loadAllocations();
    } catch (error: any) {
      showToast(error.message || "Failed to submit feedback", "error");
    }
  };

  const handleMarkComplete = (reviewType: ReviewType) => {
    if (!selectedGroup) return;
    const session = getReviewSession(selectedGroup.id, reviewType);
    if (!session) return;
    try {
      markReviewComplete(session.id);
      showToast("Review marked complete!", "success");
      if (selectedTeam) loadTeamData(selectedTeam);
      loadAllocations();
    } catch (error: any) {
      showToast(error.message || "Failed to mark complete", "error");
    }
  };

  const handleSendReviewMessage = (
    reviewType: ReviewType,
    content: string,
    links?: string[]
  ) => {
    if (!selectedGroup || !profile) return;
    const session = getReviewSession(selectedGroup.id, reviewType);
    if (!session) return;
    try {
      addReviewMessage(
        session.id,
        selectedGroup.id,
        profile.id,
        profile.name,
        content,
        "faculty",
        links
      );
      if (selectedTeam) loadTeamData(selectedTeam);
    } catch (error: any) {
      showToast(error.message || "Failed to send message", "error");
    }
  };

  const hasApprovedTopic = topics.some((t) => t.status === "approved");

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

        {/* Project Progress Section */}
        {teamProgress.length > 0 && (
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <ClipboardList className="h-5 w-5" />
                Project Progress
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {teamProgress.map((team) => (
                  <div
                    key={team.groupId}
                    className="border border-gray-200 rounded-lg p-4 hover:border-primary/50 transition-colors"
                  >
                    <div className="flex items-center justify-between mb-3">
                      <div>
                        <h4 className="font-semibold">{team.groupDisplayId}</h4>
                        {team.topicApproval.approvedTopic && (
                          <p className="text-sm text-gray-600 truncate max-w-[300px]">
                            {team.topicApproval.approvedTopic}
                          </p>
                        )}
                      </div>
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => openTeamDialog(team)}
                        className="gap-1"
                      >
                        <Eye className="h-4 w-4" />
                        View
                      </Button>
                    </div>

                    {/* Progress Indicators */}
                    <div className="grid grid-cols-4 gap-2">
                      <div className="text-center">
                        <Badge
                          variant={
                            team.topicApproval.status === "approved"
                              ? "success"
                              : team.topicApproval.totalTopicsSubmitted > 0
                              ? "warning"
                              : "outline"
                          }
                          className="text-xs"
                        >
                          Topic
                        </Badge>
                        <p className="text-xs text-gray-500 mt-1">
                          {team.topicApproval.status === "approved"
                            ? "✓"
                            : team.topicApproval.totalTopicsSubmitted > 0
                            ? `${team.topicApproval.totalTopicsSubmitted} pending`
                            : "—"}
                        </p>
                      </div>
                      <div className="text-center">
                        <Badge
                          variant={
                            team.review1.status === "completed"
                              ? "success"
                              : team.review1.status !== "not_started"
                              ? "warning"
                              : "outline"
                          }
                          className="text-xs"
                        >
                          R1
                        </Badge>
                        <p className="text-xs text-gray-500 mt-1">
                          {team.review1.status === "completed"
                            ? "✓"
                            : team.review1.progressPercentage
                            ? `${team.review1.progressPercentage}%`
                            : team.review1.isRolledOut
                            ? "—"
                            : "🔒"}
                        </p>
                      </div>
                      <div className="text-center">
                        <Badge
                          variant={
                            team.review2.status === "completed"
                              ? "success"
                              : team.review2.status !== "not_started"
                              ? "warning"
                              : "outline"
                          }
                          className="text-xs"
                        >
                          R2
                        </Badge>
                        <p className="text-xs text-gray-500 mt-1">
                          {team.review2.status === "completed"
                            ? "✓"
                            : team.review2.progressPercentage
                            ? `${team.review2.progressPercentage}%`
                            : team.review2.isRolledOut
                            ? "—"
                            : "🔒"}
                        </p>
                      </div>
                      <div className="text-center">
                        <Badge
                          variant={
                            team.finalReview.status === "completed"
                              ? "success"
                              : team.finalReview.status !== "not_started"
                              ? "warning"
                              : "outline"
                          }
                          className="text-xs"
                        >
                          Final
                        </Badge>
                        <p className="text-xs text-gray-500 mt-1">
                          {team.finalReview.status === "completed"
                            ? "✓"
                            : team.finalReview.progressPercentage
                            ? `${team.finalReview.progressPercentage}%`
                            : team.finalReview.isRolledOut
                            ? "—"
                            : "🔒"}
                        </p>
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

      {/* Team Progress Dialog */}
      <Dialog open={showTeamDialog} onOpenChange={setShowTeamDialog}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center justify-between">
              <span>
                {selectedTeam?.groupDisplayId} - Project Progress
              </span>
              <Button
                variant="ghost"
                size="sm"
                onClick={refreshTeamData}
                className="gap-1"
              >
                <RefreshCw className="h-4 w-4" />
                Refresh
              </Button>
            </DialogTitle>
          </DialogHeader>

          {selectedTeam && selectedGroup && profile && (
            <Tabs value={activeTab} onValueChange={setActiveTab}>
              <TabsList className="w-full grid grid-cols-4">
                <TabsTrigger value="topic">Topic</TabsTrigger>
                <TabsTrigger value="review1" disabled={!hasApprovedTopic}>
                  R1
                </TabsTrigger>
                <TabsTrigger
                  value="review2"
                  disabled={!hasApprovedTopic || review1Session?.status !== "completed"}
                >
                  R2
                </TabsTrigger>
                <TabsTrigger
                  value="final"
                  disabled={!hasApprovedTopic || review2Session?.status !== "completed"}
                >
                  Final
                </TabsTrigger>
              </TabsList>

              <TabsContent value="topic">
                <TopicApprovalSection
                  topics={topics}
                  messages={topicMessages}
                  currentUserId={profile.id}
                  currentUserName={profile.name}
                  currentUserRole="faculty"
                  groupId={selectedGroup.id}
                  isLeader={false}
                  onSubmitTopic={handleSubmitTopic}
                  onApproveTopic={handleApproveTopic}
                  onRejectTopic={handleRejectTopic}
                  onRequestRevision={handleRequestRevision}
                  onSendMessage={handleSendTopicMessage}
                />
              </TabsContent>

              <TabsContent value="review1">
                <ReviewSection
                  reviewType="review_1"
                  session={review1Session}
                  messages={review1Messages}
                  currentUserId={profile.id}
                  currentUserName={profile.name}
                  currentUserRole="faculty"
                  isRolledOut={review1RolledOut}
                  isUnlocked={hasApprovedTopic}
                  isLeader={false}
                  onSubmitProgress={(p, d) => handleSubmitProgress("review_1", p, d)}
                  onUpdateProgress={(p, d) => handleUpdateProgress("review_1", p, d)}
                  onSubmitFeedback={(f) => handleSubmitFeedback("review_1", f)}
                  onSendMessage={(c, l) => handleSendReviewMessage("review_1", c, l)}
                  onMarkComplete={() => handleMarkComplete("review_1")}
                />
              </TabsContent>

              <TabsContent value="review2">
                <ReviewSection
                  reviewType="review_2"
                  session={review2Session}
                  messages={review2Messages}
                  currentUserId={profile.id}
                  currentUserName={profile.name}
                  currentUserRole="faculty"
                  isRolledOut={review2RolledOut}
                  isUnlocked={review1Session?.status === "completed"}
                  isLeader={false}
                  onSubmitProgress={(p, d) => handleSubmitProgress("review_2", p, d)}
                  onUpdateProgress={(p, d) => handleUpdateProgress("review_2", p, d)}
                  onSubmitFeedback={(f) => handleSubmitFeedback("review_2", f)}
                  onSendMessage={(c, l) => handleSendReviewMessage("review_2", c, l)}
                  onMarkComplete={() => handleMarkComplete("review_2")}
                />
              </TabsContent>

              <TabsContent value="final">
                <ReviewSection
                  reviewType="final_review"
                  session={finalReviewSession}
                  messages={finalReviewMessages}
                  currentUserId={profile.id}
                  currentUserName={profile.name}
                  currentUserRole="faculty"
                  isRolledOut={finalReviewRolledOut}
                  isUnlocked={review2Session?.status === "completed"}
                  isLeader={false}
                  onSubmitProgress={(p, d) => handleSubmitProgress("final_review", p, d)}
                  onUpdateProgress={(p, d) => handleUpdateProgress("final_review", p, d)}
                  onSubmitFeedback={(f) => handleSubmitFeedback("final_review", f)}
                  onSendMessage={(c, l) => handleSendReviewMessage("final_review", c, l)}
                  onMarkComplete={() => handleMarkComplete("final_review")}
                />
              </TabsContent>
            </Tabs>
          )}
        </DialogContent>
      </Dialog>
    </DashboardLayout>
  );
}


"use client";

import { useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import { ArrowLeft, RefreshCw } from "lucide-react";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Button } from "@/components/ui/button";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { TopicApprovalSection } from "@/components/topic-approval-section";
import { ReviewSection } from "@/components/review-section";
import { useAuth } from "@/lib/auth-context";
import { useToast } from "@/components/ui/toast";
import {
  groupApi,
  mentorAllocationApi,
  projectTopicsApi,
  reviewsApi,
} from "@/lib/api";
import {
  Group,
  Profile,
  ProjectTopic,
  TopicMessage,
  ReviewSession as ReviewSessionType,
  ReviewMessage,
  ReviewType,
} from "@/types";

export default function ProjectProgressPage() {
  const router = useRouter();
  const { user, profile, loading: authLoading } = useAuth();
  const { showToast } = useToast();

  const [group, setGroup] = useState<Group | null>(null);
  const [mentor, setMentor] = useState<Profile | null>(null);
  const [activeTab, setActiveTab] = useState("topic");
  const [refreshKey, setRefreshKey] = useState(0);

  // Topic Approval State
  const [topics, setTopics] = useState<ProjectTopic[]>([]);
  const [topicMessages, setTopicMessages] = useState<TopicMessage[]>([]);

  // Review States
  const [review1RolledOut, setReview1RolledOut] = useState(false);
  const [review2RolledOut, setReview2RolledOut] = useState(false);
  const [finalReviewRolledOut, setFinalReviewRolledOut] = useState(false);

  const [review1Session, setReview1Session] =
    useState<ReviewSessionType | null>(null);
  const [review2Session, setReview2Session] =
    useState<ReviewSessionType | null>(null);
  const [finalReviewSession, setFinalReviewSession] =
    useState<ReviewSessionType | null>(null);

  const [review1Messages, setReview1Messages] = useState<ReviewMessage[]>([]);
  const [review2Messages, setReview2Messages] = useState<ReviewMessage[]>([]);
  const [finalReviewMessages, setFinalReviewMessages] = useState<
    ReviewMessage[]
  >([]);

  const loadData = useCallback(async () => {
    if (!profile) return;

    try {
      // Get group
      const userGroup = await groupApi.getMyGroup();
      if (!userGroup) {
        router.push("/dashboard/student");
        return;
      }
      setGroup(userGroup);

      // Check for accepted mentor
      const statusData = await mentorAllocationApi.getStatus();
      if (statusData.status !== 'accepted' || !statusData.mentorId) {
        router.push("/dashboard/student");
        return;
      }

      // Get mentor profile from the group's allocation data
      const allocations = await mentorAllocationApi.getForGroup();
      const acceptedAllocation = allocations.find((a) => a.status === "accepted");
      if (acceptedAllocation) {
        setMentor(acceptedAllocation.mentor);
      }

      // Load topics and messages
      const groupTopics = await projectTopicsApi.getMyGroupTopics();
      setTopics(groupTopics);

      const messages = await projectTopicsApi.getMyGroupMessages();
      setTopicMessages(messages);

      // Load review rollouts
      const review1Rollout = await reviewsApi.getRollout("review_1");
      const review2Rollout = await reviewsApi.getRollout("review_2");
      const finalReviewRollout = await reviewsApi.getRollout("final_review");

      setReview1RolledOut(!!review1Rollout?.isActive);
      setReview2RolledOut(!!review2Rollout?.isActive);
      setFinalReviewRolledOut(!!finalReviewRollout?.isActive);

      // Load review sessions
      const r1Session = await reviewsApi.getMySession("review_1");
      const r2Session = await reviewsApi.getMySession("review_2");
      const frSession = await reviewsApi.getMySession("final_review");

      setReview1Session(r1Session);
      setReview2Session(r2Session);
      setFinalReviewSession(frSession);

      // Load review messages
      const r1Messages = await reviewsApi.getMyMessages("review_1");
      const r2Messages = await reviewsApi.getMyMessages("review_2");
      const frMessages = await reviewsApi.getMyMessages("final_review");

      setReview1Messages(r1Messages);
      setReview2Messages(r2Messages);
      setFinalReviewMessages(frMessages);
    } catch (error) {
      console.error("Error loading data:", error);
      showToast("Failed to load data", "error");
    }
  }, [profile, router, showToast]);

  useEffect(() => {
    // Wait for auth to finish loading
    if (authLoading) return;
    
    if (!user || !profile) {
      router.push("/auth/login");
      return;
    }

    if (profile.role !== "student") {
      router.push("/dashboard");
      return;
    }

    loadData();
  }, [user, profile, router, refreshKey, loadData, authLoading]);

  const handleRefresh = () => {
    setRefreshKey((k) => k + 1);
    showToast("Data refreshed", "info");
  };

  const isLeader = group && profile && group.createdBy === profile.id;
  const hasApprovedTopic = topics.some((t) => t.status === "approved");

  // Topic Approval Handlers
  const handleSubmitTopic = async (title: string, description: string) => {
    if (!group || !profile) return;
    try {
      await projectTopicsApi.create({ title, description });
      showToast("Topic submitted successfully!", "success");
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to submit topic", "error");
    }
  };

  const handleApproveTopic = async (topicId: string) => {
    if (!profile) return;
    try {
      await projectTopicsApi.approve(topicId);
      showToast("Topic approved!", "success");
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to approve topic", "error");
    }
  };

  const handleRejectTopic = async (topicId: string) => {
    if (!profile) return;
    try {
      await projectTopicsApi.reject(topicId);
      showToast("Topic rejected", "info");
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to reject topic", "error");
    }
  };

  const handleRequestRevision = async (topicId: string, feedback: string) => {
    if (!profile) return;
    try {
      await projectTopicsApi.requestRevision(topicId, feedback);
      showToast("Revision requested", "success");
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to request revision", "error");
    }
  };

  const handleSendTopicMessage = async (content: string, links?: string[]) => {
    if (!group || !profile) return;
    try {
      await projectTopicsApi.addMessage({
        topicId: "general",
        content,
        links,
      });
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to send message", "error");
    }
  };

  // Review Handlers
  const handleSubmitProgress = async (
    reviewType: ReviewType,
    percentage: number,
    description: string
  ) => {
    if (!group || !profile) return;
    try {
      await reviewsApi.submitProgress(reviewType, {
        progressPercentage: percentage,
        progressDescription: description,
      });
      showToast("Progress submitted!", "success");
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to submit progress", "error");
    }
  };

  const handleUpdateProgress = async (
    reviewType: ReviewType,
    percentage: number,
    description: string
  ) => {
    if (!group || !profile) return;
    try {
      await reviewsApi.submitProgress(reviewType, {
        progressPercentage: percentage,
        progressDescription: description,
      });
      showToast("Progress updated!", "success");
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to update progress", "error");
    }
  };

  const handleSubmitFeedback = async (reviewType: ReviewType, feedback: string) => {
    if (!profile) return;
    try {
      const session = await reviewsApi.getMySession(reviewType);
      if (!session) return;
      await reviewsApi.submitFeedback(session.id, feedback);
      showToast("Feedback submitted!", "success");
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to submit feedback", "error");
    }
  };

  const handleMarkComplete = async (reviewType: ReviewType) => {
    try {
      const session = await reviewsApi.getMySession(reviewType);
      if (!session) return;
      await reviewsApi.markComplete(session.id);
      showToast("Review marked complete!", "success");
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to mark complete", "error");
    }
  };

  const handleSendReviewMessage = async (
    reviewType: ReviewType,
    content: string,
    links?: string[]
  ) => {
    if (!profile) return;
    try {
      const session = await reviewsApi.getMySession(reviewType);
      if (!session) return;
      await reviewsApi.addMessage({
        sessionId: session.id,
        content,
        links,
      });
      await loadData();
    } catch (error: any) {
      showToast(error.message || "Failed to send message", "error");
    }
  };

  if (!group || !mentor || !profile) {
    return (
      <DashboardLayout title="Project Progress">
        <div className="max-w-4xl mx-auto">
          <div className="text-center py-12 text-gray-500">Loading...</div>
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout title="Project Progress">
      <div className="max-w-4xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <Button
            variant="ghost"
            onClick={() => router.push("/dashboard/student")}
            className="gap-2"
          >
            <ArrowLeft className="h-4 w-4" />
            Back to Dashboard
          </Button>
          <Button variant="outline" onClick={handleRefresh} className="gap-2">
            <RefreshCw className="h-4 w-4" />
            Refresh
          </Button>
        </div>

        {/* Group Info */}
        <div className="bg-white border border-gray-200 rounded-lg p-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="font-semibold text-lg">Group {group.groupId}</h2>
              <p className="text-sm text-gray-600">
                Mentor: <span className="font-medium">{mentor.name}</span>
              </p>
            </div>
            {hasApprovedTopic && (
              <div className="text-right">
                <p className="text-xs text-gray-500">Approved Topic</p>
                <p className="font-medium text-green-700">
                  {topics.find((t) => t.status === "approved")?.title}
                </p>
              </div>
            )}
          </div>
        </div>

        {/* Tabs */}
        <Tabs value={activeTab} onValueChange={setActiveTab}>
          <TabsList className="w-full grid grid-cols-4">
            <TabsTrigger value="topic">Topic Approval</TabsTrigger>
            <TabsTrigger value="review1" disabled={!hasApprovedTopic}>
              Review 1
            </TabsTrigger>
            <TabsTrigger
              value="review2"
              disabled={
                !hasApprovedTopic || review1Session?.status !== "completed"
              }
            >
              Review 2
            </TabsTrigger>
            <TabsTrigger
              value="final"
              disabled={
                !hasApprovedTopic || review2Session?.status !== "completed"
              }
            >
              Final Review
            </TabsTrigger>
          </TabsList>

          {/* Topic Approval */}
          <TabsContent value="topic">
            <TopicApprovalSection
              topics={topics}
              messages={topicMessages}
              currentUserId={profile.id}
              currentUserName={profile.name}
              currentUserRole="student"
              groupId={group.id}
              isLeader={isLeader ?? false}
              onSubmitTopic={handleSubmitTopic}
              onApproveTopic={handleApproveTopic}
              onRejectTopic={handleRejectTopic}
              onRequestRevision={handleRequestRevision}
              onSendMessage={handleSendTopicMessage}
            />
          </TabsContent>

          {/* Review 1 */}
          <TabsContent value="review1">
            <ReviewSection
              reviewType="review_1"
              session={review1Session}
              messages={review1Messages}
              currentUserId={profile.id}
              currentUserName={profile.name}
              currentUserRole="student"
              isRolledOut={review1RolledOut}
              isUnlocked={hasApprovedTopic}
              isLeader={isLeader ?? false}
              onSubmitProgress={(p, d) =>
                handleSubmitProgress("review_1", p, d)
              }
              onUpdateProgress={(p, d) =>
                handleUpdateProgress("review_1", p, d)
              }
              onSubmitFeedback={(f) => handleSubmitFeedback("review_1", f)}
              onSendMessage={(c, l) =>
                handleSendReviewMessage("review_1", c, l)
              }
              onMarkComplete={() => handleMarkComplete("review_1")}
            />
          </TabsContent>

          {/* Review 2 */}
          <TabsContent value="review2">
            <ReviewSection
              reviewType="review_2"
              session={review2Session}
              messages={review2Messages}
              currentUserId={profile.id}
              currentUserName={profile.name}
              currentUserRole="student"
              isRolledOut={review2RolledOut}
              isUnlocked={review1Session?.status === "completed"}
              isLeader={isLeader ?? false}
              onSubmitProgress={(p, d) =>
                handleSubmitProgress("review_2", p, d)
              }
              onUpdateProgress={(p, d) =>
                handleUpdateProgress("review_2", p, d)
              }
              onSubmitFeedback={(f) => handleSubmitFeedback("review_2", f)}
              onSendMessage={(c, l) =>
                handleSendReviewMessage("review_2", c, l)
              }
              onMarkComplete={() => handleMarkComplete("review_2")}
            />
          </TabsContent>

          {/* Final Review */}
          <TabsContent value="final">
            <ReviewSection
              reviewType="final_review"
              session={finalReviewSession}
              messages={finalReviewMessages}
              currentUserId={profile.id}
              currentUserName={profile.name}
              currentUserRole="student"
              isRolledOut={finalReviewRolledOut}
              isUnlocked={review2Session?.status === "completed"}
              isLeader={isLeader ?? false}
              onSubmitProgress={(p, d) =>
                handleSubmitProgress("final_review", p, d)
              }
              onUpdateProgress={(p, d) =>
                handleUpdateProgress("final_review", p, d)
              }
              onSubmitFeedback={(f) => handleSubmitFeedback("final_review", f)}
              onSendMessage={(c, l) =>
                handleSendReviewMessage("final_review", c, l)
              }
              onMarkComplete={() => handleMarkComplete("final_review")}
            />
          </TabsContent>
        </Tabs>
      </div>
    </DashboardLayout>
  );
}

-- CreateTable
CREATE TABLE "TopicApprovalDocument" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "filename" TEXT NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "fileSize" INTEGER NOT NULL,
    "mimeType" TEXT NOT NULL,
    "uploadedBy" TEXT NOT NULL,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TopicApprovalDocument_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReviewEvaluation" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "reviewType" "ReviewType" NOT NULL,
    "evaluationDate" TIMESTAMP(3) NOT NULL,
    "division" TEXT NOT NULL,
    "projectGuide" TEXT NOT NULL,
    "projectTitle" TEXT NOT NULL,
    "projectCategory" TEXT,
    "projectType" TEXT,
    "projectDomain" TEXT,
    "qualityGrade" TEXT,
    "projectNature" TEXT,
    "completionPercentage" INTEGER NOT NULL,
    "remarks" TEXT,
    "filledBy" TEXT NOT NULL,
    "filledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ReviewEvaluation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StudentGrade" (
    "id" TEXT NOT NULL,
    "evaluationId" TEXT NOT NULL,
    "profileId" TEXT NOT NULL,
    "studentName" TEXT NOT NULL,
    "rollNumber" TEXT NOT NULL,
    "progressMarks" INTEGER,
    "contributionMarks" INTEGER,
    "publicationMarks" INTEGER,
    "techUsageMarks" INTEGER,
    "innovationMarks" INTEGER,
    "presentationMarks" INTEGER,
    "activityMarks" INTEGER,
    "synopsisMarks" INTEGER,
    "totalMarks" INTEGER NOT NULL,

    CONSTRAINT "StudentGrade_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "TopicApprovalDocument_groupId_key" ON "TopicApprovalDocument"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "ReviewEvaluation_sessionId_key" ON "ReviewEvaluation"("sessionId");

-- CreateIndex
CREATE INDEX "ReviewEvaluation_groupId_idx" ON "ReviewEvaluation"("groupId");

-- CreateIndex
CREATE INDEX "ReviewEvaluation_reviewType_idx" ON "ReviewEvaluation"("reviewType");

-- CreateIndex
CREATE INDEX "StudentGrade_evaluationId_idx" ON "StudentGrade"("evaluationId");

-- AddForeignKey
ALTER TABLE "TopicApprovalDocument" ADD CONSTRAINT "TopicApprovalDocument_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TopicApprovalDocument" ADD CONSTRAINT "TopicApprovalDocument_uploadedBy_fkey" FOREIGN KEY ("uploadedBy") REFERENCES "Profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReviewEvaluation" ADD CONSTRAINT "ReviewEvaluation_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "ReviewSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReviewEvaluation" ADD CONSTRAINT "ReviewEvaluation_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReviewEvaluation" ADD CONSTRAINT "ReviewEvaluation_filledBy_fkey" FOREIGN KEY ("filledBy") REFERENCES "Profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentGrade" ADD CONSTRAINT "StudentGrade_evaluationId_fkey" FOREIGN KEY ("evaluationId") REFERENCES "ReviewEvaluation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentGrade" ADD CONSTRAINT "StudentGrade_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "Profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

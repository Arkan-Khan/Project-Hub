-- CreateEnum
CREATE TYPE "AttachmentStage" AS ENUM ('topic_approval', 'review_1', 'review_2', 'final_review');

-- CreateTable
CREATE TABLE "Attachment" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "stage" "AttachmentStage" NOT NULL,
    "filename" TEXT NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "fileSize" INTEGER NOT NULL,
    "mimeType" TEXT NOT NULL,
    "uploadedBy" TEXT NOT NULL,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Attachment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Attachment_groupId_idx" ON "Attachment"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "Attachment_groupId_stage_key" ON "Attachment"("groupId", "stage");

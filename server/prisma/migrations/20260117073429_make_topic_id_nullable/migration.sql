-- AlterTable
ALTER TABLE "TopicMessage" ALTER COLUMN "topicId" DROP NOT NULL;

-- CreateIndex
CREATE INDEX "TopicMessage_topicId_idx" ON "TopicMessage"("topicId");

-- CreateIndex
CREATE INDEX "TopicMessage_groupId_idx" ON "TopicMessage"("groupId");

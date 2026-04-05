-- DropIndex
DROP INDEX "Attachment_groupId_stage_key";

-- AlterTable
ALTER TABLE "Attachment" ALTER COLUMN "stage" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Attachment" ADD CONSTRAINT "Attachment_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attachment" ADD CONSTRAINT "Attachment_uploadedBy_fkey" FOREIGN KEY ("uploadedBy") REFERENCES "Profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

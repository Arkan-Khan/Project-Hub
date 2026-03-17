-- AlterEnum
ALTER TYPE "AllocationStatus" ADD VALUE 'waiting';

-- AlterTable
ALTER TABLE "Group" ADD COLUMN     "meetLink" TEXT;

-- AlterTable
ALTER TABLE "Profile" ADD COLUMN     "domains" TEXT;

-- AlterTable
ALTER TABLE "ReviewSession" ADD COLUMN     "meetLink" TEXT;

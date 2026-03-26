"use client";

import * as React from "react";
import {
  Upload,
  FileText,
  Trash2,
  Download,
  AlertCircle,
  CheckCircle,
  Clock,
  File,
  Image as ImageIcon,
  FileSpreadsheet,
} from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Attachment, AttachmentStage } from "@/types";

interface AttachmentsTabProps {
  attachments: Attachment[];
  isLeader: boolean;
  onUpload: (stage: AttachmentStage, file: File) => Promise<void>;
  onDelete: (attachmentId: string) => Promise<void>;
  loading?: boolean;
}

const STAGES: { key: AttachmentStage; label: string; description: string }[] = [
  {
    key: "topic_approval",
    label: "Topic Approval",
    description: "Upload documents related to your project topic",
  },
  {
    key: "review_1",
    label: "Review 1",
    description: "Upload progress report for Review 1",
  },
  {
    key: "review_2",
    label: "Review 2",
    description: "Upload progress report for Review 2",
  },
  {
    key: "final_review",
    label: "Final Review",
    description: "Upload final project documentation",
  },
];

const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

function getFileIcon(mimeType: string) {
  if (mimeType.startsWith("image/")) {
    return <ImageIcon className="h-5 w-5 text-blue-500" />;
  }
  if (mimeType.includes("pdf")) {
    return <FileText className="h-5 w-5 text-red-500" />;
  }
  if (mimeType.includes("spreadsheet") || mimeType.includes("excel")) {
    return <FileSpreadsheet className="h-5 w-5 text-green-500" />;
  }
  return <File className="h-5 w-5 text-gray-500" />;
}

interface StageCardProps {
  stage: (typeof STAGES)[0];
  attachment: Attachment | undefined;
  isLeader: boolean;
  onUpload: (file: File) => Promise<void>;
  onDelete: () => Promise<void>;
}

function StageCard({
  stage,
  attachment,
  isLeader,
  onUpload,
  onDelete,
}: StageCardProps) {
  const [uploading, setUploading] = React.useState(false);
  const [deleting, setDeleting] = React.useState(false);
  const [error, setError] = React.useState<string | null>(null);
  const fileInputRef = React.useRef<HTMLInputElement>(null);

  const handleFileSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate file size
    if (file.size > MAX_FILE_SIZE) {
      setError("File size exceeds 5 MB limit");
      return;
    }

    setError(null);
    setUploading(true);
    try {
      await onUpload(file);
    } catch (err: any) {
      setError(err.message || "Upload failed");
    } finally {
      setUploading(false);
      if (fileInputRef.current) {
        fileInputRef.current.value = "";
      }
    }
  };

  const handleDelete = async () => {
    if (!attachment) return;
    if (!confirm("Are you sure you want to delete this attachment?")) return;

    setDeleting(true);
    try {
      await onDelete();
    } catch (err: any) {
      setError(err.message || "Delete failed");
    } finally {
      setDeleting(false);
    }
  };

  return (
    <Card className={attachment ? "border-green-200 bg-green-50/30" : ""}>
      <CardContent className="p-4">
        <div className="flex items-start justify-between gap-4">
          <div className="flex-1">
            <div className="flex items-center gap-2">
              <h4 className="font-medium">{stage.label}</h4>
              {attachment ? (
                <Badge variant="success" className="text-xs">
                  <CheckCircle className="h-3 w-3 mr-1" />
                  Uploaded
                </Badge>
              ) : (
                <Badge variant="outline" className="text-xs">
                  Not Uploaded
                </Badge>
              )}
            </div>
            <p className="text-sm text-gray-500 mt-1">{stage.description}</p>

            {attachment && (
              <div className="mt-3 p-3 bg-white rounded-lg border flex items-center gap-3">
                {getFileIcon(attachment.mimeType)}
                <div className="flex-1 min-w-0">
                  <p
                    className="text-sm font-medium truncate"
                    title={attachment.filename}
                  >
                    {attachment.filename}
                  </p>
                  <p className="text-xs text-gray-500">
                    {formatFileSize(attachment.fileSize)} •{" "}
                    {new Date(attachment.uploadedAt).toLocaleDateString()}
                  </p>
                </div>
                <div className="flex items-center gap-2">
                  <a
                    href={attachment.fileUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="p-2 hover:bg-gray-100 rounded-md transition-colors"
                    title="Download"
                  >
                    <Download className="h-4 w-4 text-gray-600" />
                  </a>
                  {isLeader && (
                    <button
                      onClick={handleDelete}
                      disabled={deleting}
                      className="p-2 hover:bg-red-100 rounded-md transition-colors disabled:opacity-50"
                      title="Delete"
                    >
                      <Trash2 className="h-4 w-4 text-red-600" />
                    </button>
                  )}
                </div>
              </div>
            )}

            {error && (
              <div className="mt-2 flex items-center gap-1 text-red-600 text-sm">
                <AlertCircle className="h-4 w-4" />
                {error}
              </div>
            )}
          </div>

          {isLeader && (
            <div>
              <input
                ref={fileInputRef}
                type="file"
                onChange={handleFileSelect}
                className="hidden"
                accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.png,.jpg,.jpeg,.gif,.zip,.rar,.txt"
              />
              <Button
                variant={attachment ? "outline" : "default"}
                size="sm"
                onClick={() => fileInputRef.current?.click()}
                disabled={uploading}
                className="gap-2"
              >
                {uploading ? (
                  <>
                    <Clock className="h-4 w-4 animate-spin" />
                    Uploading...
                  </>
                ) : (
                  <>
                    <Upload className="h-4 w-4" />
                    {attachment ? "Replace" : "Upload"}
                  </>
                )}
              </Button>
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

export function AttachmentsTab({
  attachments,
  isLeader,
  onUpload,
  onDelete,
  loading,
}: AttachmentsTabProps) {
  const getAttachmentForStage = (stage: AttachmentStage) =>
    attachments.find((a) => a.stage === stage);

  if (loading) {
    return (
      <Card>
        <CardContent className="py-12">
          <div className="text-center text-gray-500">
            <Clock className="h-8 w-8 mx-auto mb-2 animate-pulse" />
            <p>Loading attachments...</p>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-4">
      {/* Header */}
      <Card>
        <CardHeader className="pb-2">
          <CardTitle className="text-lg flex items-center gap-2">
            <FileText className="h-5 w-5" />
            Project Attachments
          </CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-gray-600">
            Upload documents for each project stage. Maximum file size: 5 MB per
            file.
          </p>
          <p className="text-sm text-gray-500 mt-1">
            Supported formats: PDF, Word, PowerPoint, Excel, Images, ZIP, RAR,
            TXT
          </p>
          {!isLeader && (
            <div className="mt-3 p-3 bg-amber-50 border border-amber-200 rounded-lg">
              <p className="text-sm text-amber-800 flex items-center gap-2">
                <AlertCircle className="h-4 w-4" />
                Only the group leader can upload or delete attachments.
              </p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Stage Cards */}
      <div className="space-y-3">
        {STAGES.map((stage) => (
          <StageCard
            key={stage.key}
            stage={stage}
            attachment={getAttachmentForStage(stage.key)}
            isLeader={isLeader}
            onUpload={(file) => onUpload(stage.key, file)}
            onDelete={() => {
              const attachment = getAttachmentForStage(stage.key);
              if (attachment) {
                return onDelete(attachment.id);
              }
              return Promise.resolve();
            }}
          />
        ))}
      </div>

      {/* Summary */}
      <div className="text-center text-sm text-gray-500">
        {attachments.length} of {STAGES.length} attachments uploaded
      </div>
    </div>
  );
}

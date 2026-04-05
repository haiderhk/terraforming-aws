resource "aws_s3_bucket_replication_configuration" "archive_storage_class_replication" {
  depends_on = [aws_s3_bucket_versioning.enable_source_versioning, aws_s3_bucket_versioning.enable_destination_versioning, aws_iam_role_policy.storage_class_replication_permissions_policy]
  role   = aws_iam_role.storage_class_replication_role.arn
  bucket = aws_s3_bucket.source_bucket.id

  rule {
    id     = "archive-replication-rule"
    status = "Enabled"
    destination {
      bucket        = aws_s3_bucket.destination_bucket.arn
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

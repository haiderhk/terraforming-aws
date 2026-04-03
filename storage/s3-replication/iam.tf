// Create the replication role and attach trust policy (S3 to assume role)
resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}


// Create permissions policy
resource "aws_iam_role_policy" "replication_permissions_policy" {
  name = "s3-replication-role-permissions-policy"
  role = aws_iam_role.replication_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = aws_s3_bucket.source_bucket.arn
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
      },
      {
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.source_bucket.arn}/*"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
        ]
      },
      {
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.destination_bucket.arn}/*"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",

        ]
      }
    ]
  })
}


// The Actual Replication configuration
resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.enable_source_bucket_versioning, aws_s3_bucket_versioning.enable_destination_bucket_versioning, aws_iam_role_policy.replication_permissions_policy]
  role       = aws_iam_role.replication_role.arn
  bucket     = aws_s3_bucket.source_bucket.id

  rule {
    id     = "replication-rule"
    status = "Enabled"
    destination {
      bucket = aws_s3_bucket.destination_bucket.arn
    }
  }
}

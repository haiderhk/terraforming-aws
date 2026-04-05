// Create a new role for Storage Class Replication.
resource "aws_iam_role" "storage_class_replication_role" {
  name = "s3-storage-class-replication-role"

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


// Attach Inline Policy / Permissions policy
resource "aws_iam_role_policy" "storage_class_replication_permissions_policy" {
  name = "s3-storage-class-replication-role-permissions-policy"
  role = aws_iam_role.storage_class_replication_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = [aws_s3_bucket.source_bucket.arn]
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
      },
      {
        Effect   = "Allow"
        Resource = ["${aws_s3_bucket.source_bucket.arn}/*"]
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
        ]
      },
      {
        Effect   = "Allow"
        Resource = ["${aws_s3_bucket.destination_bucket.arn}/*"]
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",

        ]
      }
    ]
  })
}

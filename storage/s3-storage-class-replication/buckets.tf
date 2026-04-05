resource "aws_s3_bucket" "source_bucket" {
  bucket = "acme-usage-data-use1"
}

resource "aws_s3_bucket" "destination_bucket" {
  provider = aws.replication-region
  bucket   = "acme-usage-data-euc1"
}


// Block public access on both
resource "aws_s3_bucket_public_access_block" "source_block_public_access" {
  bucket = aws_s3_bucket.source_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "destination_block_public_access" {
  provider = aws.replication-region
  bucket   = aws_s3_bucket.destination_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


// Enable Versioning on both
resource "aws_s3_bucket_versioning" "enable_source_versioning" {
  bucket = aws_s3_bucket.source_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "enable_destination_versioning" {
  provider = aws.replication-region
  bucket   = aws_s3_bucket.destination_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
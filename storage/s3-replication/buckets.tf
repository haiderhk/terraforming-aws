
// Create the two buckets
resource "aws_s3_bucket" "source_bucket" {
  bucket = "acme-datalake-raw-use1"
}

resource "aws_s3_bucket" "destination_bucket" {
  provider = aws.replication-region
  bucket   = "acme-datalake-raw-euc1"
}


// Block public access on both
resource "aws_s3_bucket_public_access_block" "source_bucket_public_access" {
  bucket = aws_s3_bucket.source_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_public_access_block" "destination_bucket_public_access" {
  provider = aws.replication-region
  bucket   = aws_s3_bucket.destination_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


// Enable versioning on both buckets
resource "aws_s3_bucket_versioning" "enable_source_bucket_versioning" {
  bucket = aws_s3_bucket.source_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_versioning" "enable_destination_bucket_versioning" {
  provider = aws.replication-region
  bucket   = aws_s3_bucket.destination_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

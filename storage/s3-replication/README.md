## S3 Replication

Amazon S3 Replication automatically and asynchronously copies objects from a source S3 bucket to a destination S3 bucket. Replication can be configured within the same AWS Region or across different AWS Regions, and it can also work across different AWS accounts.

This example uses **Cross-Region Replication (CRR)** to replicate objects from a source bucket in one AWS Region to a destination bucket in another AWS Region.

A few important points about S3 Replication:
- Replication only applies to new objects uploaded after replication is enabled
- Existing objects can be replicated separately using **S3 Batch Replication**
- Versioning must be enabled on both the source and destination buckets

## When to Use Cross-Region Replication

Cross-Region Replication (CRR) is useful when:
- Compliance requirements require data to be stored farther away from the primary location
- You want lower latency for users in different geographic regions by keeping copies of data closer to them
- You want a disaster recovery copy of important data in another AWS Region

## When to Use Same-Region Replication

Same-Region Replication (SRR) is useful when:
- You want to aggregate logs from multiple buckets or accounts into a single bucket in the same Region
- You need multiple copies of data in separate AWS accounts within the same Region
- Data sovereignty or compliance rules do not allow data to leave the country or Region


## Terraform Resources Used


- `aws_s3_bucket` to create the source and destination S3 buckets
- `aws_s3_bucket_public_access_block` to block public access on both buckets
- `aws_s3_bucket_versioning` to enable versioning, which is required for replication
- `aws_iam_role` to create the IAM role assumed by Amazon S3 for replication
- `aws_iam_role_policy` to grant the permissions required for replicating objects
- `aws_s3_bucket_replication_configuration` to configure cross-region replication from the source bucket to the destination bucket

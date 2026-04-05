## S3 Replication to Glacier Deep Archive


Replicated objects in the destination bucket are stored using the `DEEP_ARCHIVE` storage class. This makes the destination copy suitable for long-term retention, compliance, and low-cost archival backup of infrequently accessed data.

A few important points about this pattern:

- Replication only applies to new objects uploaded after replication is enabled
- Existing objects can be replicated separately using **S3 Batch Replication**
- Versioning must be enabled on both the source and destination buckets
- The destination is still a normal S3 bucket; the replicated objects are what use the `DEEP_ARCHIVE` storage class
- Objects stored in Glacier Deep Archive cannot be accessed immediately and must be restored before use

## When to Use Replication to an Archival Storage Class

Replicating objects into an archival storage class like Glacier Deep Archive is useful when:

- You need a low-cost archival copy of important data in another AWS Region
- Compliance requirements require long-term retention of datasets
- You want a disaster recovery or backup copy for cold data
- You want to keep rarely accessed but important data for multiple years at the lowest storage cost


## S3 Glacier Deep Archive

S3 Glacier Deep Archive is one of Amazon S3's archival storage classes and is designed for data that is accessed very rarely. It is a good fit for long-term retention, regulatory archives, and backup datasets that you do not need to retrieve quickly.

Because objects in this storage class are archived, they are not directly accessible in the same way as objects in S3 Standard. To access them, you must first submit a restore request, which creates a temporary copy for a duration that you specify.

S3 Glacier Deep Archive is the lowest-cost storage option in AWS.


## Glacier Storage Class Comparison


| S3 Glacier storage class | Minimum storage duration | Recommended access frequency | Average retrieval times | Archival? |
| --- | --- | --- | --- | --- |
| S3 Glacier Instant Retrieval | 90 days | Quarterly | Milliseconds | No |
| S3 Glacier Flexible Retrieval | 90 days | Semi-annually | Minutes to 12 hours | Yes |
| S3 Glacier Deep Archive | 180 days | Annually | 9 to 48 hours | Yes |

## Terraform Resources Used

- `aws_s3_bucket` to create the source and destination S3 buckets
- `aws_s3_bucket_public_access_block` to block public access on both buckets
- `aws_s3_bucket_versioning` to enable versioning, which is required for replication
- `aws_iam_role` to create the IAM role assumed by Amazon S3 for replication
- `aws_iam_role_policy` to grant the permissions required for replicating objects
- `aws_s3_bucket_replication_configuration` to configure cross-region replication and store replicated objects in the `DEEP_ARCHIVE` storage class

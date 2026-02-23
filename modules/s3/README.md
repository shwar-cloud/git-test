This architecture implements secure and highly available object storage using Amazon S3 multi-tier lifecycle management with cross-region replication.

Storage Layer :
(1) Source bucket in us-east-1
(2) Destination bucket in us-west-2

Both bucket enabled with Versioning,KMS encryption. Versioning → protects from accidental delete KMS → protects data at rest Bucket policy → blocks unencrypted uploads

For Encryption - Separate KMS key per region, Lifecycle - This reduces storage cost automatically based on object age, Cross-Region Replication : Replicates from us-east-1 to us-west-2, Uses IAM Role created by S3, Replicates Encrypted objects. Monitoring & Alerting – Amazon CloudWatch

Testing :
To check file replication and encryption status aws s3api head-object --bucket source-sclrbucket1 --key yourfile.txt --region us-east-1

Check for default encryption is enabled
aws s3api get-bucket-encryption --bucket source-sclrbucket1

Lists all the SNS topics in AWS account for the specified region.
aws sns list-topics --region us-east-1

List all subscriptions for a specific SNS topic
aws sns list-subscriptions-by-topic --topic-arn arn:aws:sns:us-east-1:348375261644:sclr-replication-alerts --region us-east-1

To check the status and configuration of the CloudWatch alarm.

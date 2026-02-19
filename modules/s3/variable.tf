variable "source_bucket" {
  type        = string
  description = "Name of the source S3 bucket"
}

variable "destination_bucket" {
  type        = string
  description = "Name of the destination S3 bucket"
}

variable "source_kms_arn" {
  type        = string
  description = "ARN of the source KMS key for server-side encryption"
}

variable "destination_kms_arn" {
  type        = string
  description = "ARN of the destination KMS key for server-side encryption"
}

variable "replication_role_arn" {
  type        = string
  description = "ARN of the IAM role used for S3 replication"
}

variable "sns_topic_arn" {
  type        = string
  description = "ARN of the SNS topic to notify replication failures"
}

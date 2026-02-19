variable "replication_role" {
  type        = string
  description = "Name or ARN of the IAM role used for S3 replication"
}

variable "source_bucket_name" {
  type        = string
  description = "Name of the source S3 bucket"
}

variable "destination_bucket_name" {
  type        = string
  description = "Name of the destination S3 bucket"
}

variable "source_kms_arn" {
  type        = string
  description = "ARN of the source KMS key"
}

variable "destination_kms_arn" {
  type        = string
  description = "ARN of the destination KMS key"
}

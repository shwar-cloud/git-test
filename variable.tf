variable "source_bucket_name" {
  type        = string
  description = "Name of the source S3 bucket"
  default     = "sclrsourcebucket"
}

variable "destination_bucket_name" {
  type        = string
  description = "Name of the destination S3 bucket"
  default     = "sclrdestinationbucket"
}


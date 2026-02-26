<<<<<<< HEAD
variable "source_bucket_name" {
  description = "Name of the source S3 bucket"
  type        = string
}

variable "destination_bucket_name" {
  description = "Name of the destination S3 bucket"
  type        = string
}

variable "source_region" {
  description = "AWS region for the source S3 bucket and KMS key"
  type        = string
}

variable "destination_region" {
  description = "AWS region for the destination S3 bucket and KMS key"
  type        = string
}
=======
variable "source_region" {
  type = string
}

variable "destination_region" {
  type = string
}

variable "bucket_name_source" {
  type = string
}

variable "bucket_name_destination" {
  type = string
}
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765

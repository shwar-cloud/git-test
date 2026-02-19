variable "topic_name" {
  description = "SNS topic name"
  type        = string
  default     = "sclr-replication-alerts"
}

variable "email" {
  description = "Email address for SNS subscription"
  type        = string
}

variable "bucket_name" {
  description = "Source bucket to monitor replication"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN to notify when alarm triggers"
  type        = string
}

variable "alarm_name" {
  description = "CloudWatch alarm name"
  type        = string
  default     = "sclr-replication-lag"
}

variable "threshold_seconds" {
  description = "Replication lag threshold in seconds"
  type        = number
  default     = 900
}

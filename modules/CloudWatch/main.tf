resource "aws_cloudwatch_metric_alarm" "replication_lag" {
  alarm_name          = var.alarm_name
  namespace           = "AWS/S3"
  metric_name         = "ReplicationTime"
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 900
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    BucketName  = var.bucket_name
    StorageType = "AllStorageTypes"
  }
}

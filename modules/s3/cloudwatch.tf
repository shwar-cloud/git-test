#replication takes longer than expected
resource "aws_cloudwatch_metric_alarm" "replication_lag" {
  alarm_name          = "sclr-replication-lag-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ReplicationLatency"
  namespace           = "AWS/S3"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60
  alarm_description   = "Alarm when S3 replication latency exceeds 1 minutes"

  dimensions = {
    BucketName = aws_s3_bucket.sclr_source.bucket  
    alarm_description = Alarm when S3 replication latency exceeds 15 minutes
  }

  alarm_actions = [
    aws_sns_topic.sclr_replication_alerts.arn    '
    #RuleId     = "sclr-replication-rule"
  ]
}

resource "aws_cloudwatch_metric_alarm" "replication_failures" {
  alarm_name          = "sclr-replication-failed-operations"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ReplicationFailedOperations"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alarm when replication failures occur"

  dimensions = {
    BucketName = aws_s3_bucket.sclr_source.bucket
    RuleId     = "sclr-replication-rule"
  }

  alarm_actions = [
    aws_sns_topic.sclr_replication_alerts.arn    
  ]
}

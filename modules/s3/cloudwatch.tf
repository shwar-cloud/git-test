<<<<<<< HEAD
# Replication takes longer than expected
=======
#replication takes longer than expected
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
resource "aws_cloudwatch_metric_alarm" "replication_lag" {
  alarm_name          = "sclr-replication-lag-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ReplicationLatency"
  namespace           = "AWS/S3"
<<<<<<< HEAD
  period              = 60  #CloudWatch evaluates every 1 minute
  statistic           = "Maximum"
  threshold           = 60   #triggers if replication takes more than 60 seconds
  alarm_description   = "Alarm when S3 replication latency exceeds 1 minute"

  dimensions = {
    BucketName = aws_s3_bucket.sclr_source.bucket
    }

  alarm_actions = [
    aws_sns_topic.sclr_replication_alert.arn
  ]
}

# Alarm triggers immediately for single object replication failures
=======
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
#  alarm triggers immediately for single object fails to replicate.
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
resource "aws_cloudwatch_metric_alarm" "replication_failures" {
  alarm_name          = "sclr-replication-failed-operations"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ReplicationFailedOperations"
  namespace           = "AWS/S3"
  period              = 300   #checks every 5 minutes
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alarm when replication failures occur"

  dimensions = {
    BucketName = aws_s3_bucket.sclr_source.bucket
    RuleId = "ReplicateKMSOnly"
  }

  alarm_actions = [
    aws_sns_topic.sclr_replication_alert.arn
  ]
}

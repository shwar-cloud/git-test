# SNS Topic for replication alerts
resource "aws_sns_topic" "sclr_replication_alert" {
  name = "sclr-replication-alert3"
}

# Email subscription s
resource "aws_sns_topic_subscription" "sclr_email_subscription" {
  topic_arn = aws_sns_topic.sclr_replication_alert.arn
  protocol  = "email"
  endpoint  = "changedev25@gmail.com"
}

# Allow S3 to publish to SNS
resource "aws_sns_topic_policy" "sclr_sns_policy" {
  arn = aws_sns_topic.sclr_replication_alert.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "s3.amazonaws.com" }  
      Action = "sns:Publish"
      Resource = aws_sns_topic.sclr_replication_alert.arn
    }]
  })
}

# S3 Bucket Notification for replication failure events
resource "aws_s3_bucket_notification" "sclr_replication_notification" {
  bucket = aws_s3_bucket.sclr_source.id

  topic {
    topic_arn = aws_sns_topic.sclr_replication_alert.arn
    events = [
      "s3:Replication:OperationFailedReplication",
      "s3:Replication:OperationMissedThreshold"
    ]
  }

  depends_on = [aws_sns_topic_policy.sclr_sns_policy]
}
resource "aws_iam_role" "sclr_replication_role" {
  name = "sclr-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "s3.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "sclr_replication_policy" {
  role = aws_iam_role.sclr_replication_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionForReplication",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.sclr_source.arn,
          "${aws_s3_bucket.sclr_source.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = [
          aws_s3_bucket.sclr_destination.arn,
          "${aws_s3_bucket.sclr_destination.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Resource = [
          aws_kms_key.sclr_source_kms.arn,
          aws_kms_key.sclr_destination_kms.arn
        ]
      }
    ]
  })
}
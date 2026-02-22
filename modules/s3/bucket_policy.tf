resource "aws_s3_bucket_policy" "sclr_source_policy" {
  bucket = aws_s3_bucket.sclr_source.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.sclr_source.arn}/*"
        Condition = { Bool = { "aws:SecureTransport" = "false" } }
      },
      {
        Effect = "Allow"
        Principal = { AWS = aws_iam_role.sclr_replication_role.arn }
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
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "sclr_destination_policy" {
  provider = aws.dr
  bucket   = aws_s3_bucket.sclr_destination.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow replication role to write objects
      {
        Effect = "Allow"
        Principal = { AWS = aws_iam_role.sclr_replication_role.arn }
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
      # 👇 Add this statement for object lock bypass
      {
        Effect = "Allow"
        Principal = { AWS = aws_iam_role.sclr_replication_role.arn }
        Action = "s3:BypassGovernanceRetention"
        Resource = [
          aws_s3_bucket.sclr_destination.arn,
          "${aws_s3_bucket.sclr_destination.arn}/*"
        ]
      }
    ]
  })
}
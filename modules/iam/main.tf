resource "aws_iam_role" "replication" {
  provider = aws.source
  name     = var.replication_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "s3.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "replication" {
  provider = aws.source
  role     = aws_iam_role.replication.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetReplicationConfiguration","s3:ListBucket"],
        Resource = "arn:aws:s3:::${var.source_bucket}"
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ],
        Resource = "arn:aws:s3:::${var.source_bucket}/*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Resource = "arn:aws:s3:::${var.destination_bucket}/*"
      },
      {
        Effect   = "Allow",
        Action   = ["kms:Decrypt","kms:DescribeKey"],
        Resource = var.source_kms_arn
      },
      {
        Effect   = "Allow",
        Action   = [
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = var.destination_kms_arn
      }
    ]
  })
}

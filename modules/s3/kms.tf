resource "aws_kms_key" "sclr_source_kms" {
  description         = "SCLR Source KMS Key"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Allow replication role usage"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.sclr_replication_role.arn
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:ReEncryptFrom"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow account admins to manage KMS"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::348375261644:root"
        }
        Action = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_key" "sclr_destination_kms" {
  provider            = aws.dr
  description         = "SCLR Destination KMS Key"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Allow replication role usage"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.sclr_replication_role.arn
        }
        Action = [
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:ReEncryptTo"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow account admins"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::348375261644:root"
        }
        Action = "kms:*"
        Resource = "*"
      }
    ]
  })
  depends_on = [aws_iam_role.sclr_replication_role]
}

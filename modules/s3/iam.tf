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
  name = sclr_replication_policy

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ProvideReadAccessToSourceBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectRetention",
          "s3:GetObjectLegalHold"
        ]
        Resource = "${aws_s3_bucket.sclr_source.arn}/*"
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
      # Write to destination bucket
      {
        Sid    = "AllowReplicationToDestinationBucket"
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:GetObjectVersionTagging",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ] 
       Resource = "${aws_s3_bucket.sclr_destination.arn}/*"
        Condition = {
          StringLikeIfExists = {
            "s3:x-amz-server-side-encryption" = ["aws:kms", "AES256"]
          }
        }
      },
       # Decrypt source objects with KMS conditions
      {
        Sid    = "AllowDecryptOfSourceObjects"
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = aws_kms_key.source_key.arn
        Condition = {
          StringLike = {
            "kms:ViaService" = "s3.${var.source_region}.amazonaws.com"
          }
        }
      },

      # Encrypt destination objects with KMS conditions
      {
        Sid    = "AllowEncryptOfDestinationObjects"
        Effect = "Allow"
        Action = [
          "kms:Encrypt"
        ]
        Resource = aws_kms_key.destination_key.arn
        Condition = {
          StringLike = {
            "kms:ViaService" = "s3.${var.destination_region}.amazonaws.com"
          }
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.replication_role_kms.name
  policy_arn = aws_iam_policy.replication_policy_kms.arn
}

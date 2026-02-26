resource "aws_iam_role" "sclr_replication_role" {     #IAM role creation
  name = "sclr_replication_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "s3.amazonaws.com" },
      Action    = "sts:AssumeRole"                   #  Allows S3 to assume role
    }]
  })
}

resource "aws_iam_policy" "sclr_replication_policy" {
  name = "sclr_replication_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration"
        ]
        Resource = aws_s3_bucket.sclr_source.arn
      },
      {
        Effect = "Allow"
        Action = [
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
          "s3:ReplicateTags",
          "s3:GetObjectVersionTagging",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource = [
          aws_s3_bucket.sclr_destination.arn,
          "${aws_s3_bucket.sclr_destination.arn}/*"
        ]
      },
       {
        Effect = "Allow"
        Action = [
          #"kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ]
        Resource = [
          aws_kms_key.sclr_source_kms.arn,
          aws_kms_key.sclr_destination_kms.arn
        ]
      } 
    ]
  }) 
}

resource "aws_iam_role_policy_attachment" "replication_attachment" {
  role       = aws_iam_role.sclr_replication_role.name
  policy_arn = aws_iam_policy.sclr_replication_policy.arn
}


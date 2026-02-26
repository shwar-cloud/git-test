<<<<<<< HEAD
resource "aws_iam_role" "sclr_replication_role" {     #IAM role creation
=======
resource "aws_iam_role" "sclr_replication_role" {
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
  name = "sclr_replication_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
<<<<<<< HEAD
      Principal = { Service = "s3.amazonaws.com" },
      Action    = "sts:AssumeRole"                   #  Allows S3 to assume role
    }]
  })
}

resource "aws_iam_policy" "sclr_replication_policy" {
  name = "sclr_replication_policy"
=======
      Principal = { 
       Service = "s3.amazonaws.com" 
    },
      Action    = "sts:AssumeRole"
    }]
  })
}
# Replication Policy
resource "aws_iam_role_policy" "sclr_replication_policy" {
  name ="sclr_replication_policy"
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ProvideReadAccessToSourceBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
<<<<<<< HEAD
          "s3:GetReplicationConfiguration"
        ]
        Resource = aws_s3_bucket.sclr_source.arn
      },
      {
        Effect = "Allow"
        Action = [
=======
          "s3:GetObjectVersion",
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
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
        Resource = "${aws_s3_bucket.sclr_destination.arn}/*"
        
      },
<<<<<<< HEAD
       {
        Effect = "Allow"
        Action = [
          #"kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
=======
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
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
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
<<<<<<< HEAD
      } 
    ]
  }) 
=======
        Resource = aws_kms_key.sclr_destination.arn
        Condition = {
          StringLike = {
            "kms:ViaService" = "s3.${var.destination_region}.amazonaws.com"
          }
        }
      }
    ]
  })
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
}

resource "aws_iam_role_policy_attachment" "replication_attachment" {
  role       = aws_iam_role.sclr_replication_role.name
  policy_arn = aws_iam_policy.sclr_replication_policy.arn
}
<<<<<<< HEAD

=======
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765

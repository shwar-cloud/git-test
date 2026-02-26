data "aws_caller_identity" "current" {}
<<<<<<< HEAD

resource "aws_kms_key" "sclr_source_kms" {
  description         = "SCLR Source KMS Key"
  enable_key_rotation = true
=======
resource "aws_kms_key" "sclr_source_kms" {
  description         = "SCLR Source KMS Key"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "RootAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },

      # Allow replication role to decrypt source with conditions
      {
        Sid    = "AllowReplicationRoleDecrypt"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.sclr_replication_role.arn
        }
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
        Condition = {
          StringLike = {
            "kms:ViaService" = "s3.${var.source_region}.amazonaws.com"
          }
        }
      }
    ]
  })
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
}

#destination kms key
resource "aws_kms_key" "sclr_destination_kms" {
  provider            = aws.dr
  description         = "SCLR Destination KMS Key"
  enable_key_rotation = true
<<<<<<< HEAD
=======

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "RootAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },

      # Allow replication role to encrypt object in destination bucket
      {
        Sid    = "AllowReplicationRoleEncrypt"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.sclr_replication_role_kms.arn
        }
        Action = [
          "kms:Encrypt"
        ]
        Resource = "*"
        Condition = {
          StringLike = {
            "kms:ViaService" = "s3.${var.destination_region}.amazonaws.com"
          }
        }
      }
    ]
  })
}
resource "aws_kms_alias" "destination_alias" {
  provider      = aws.dr
  name          = "alias/s3-destination-key"
  target_key_id = aws_kms_key.sclr_destination_kms.key_id
}

#source Server side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "sclr_source_encryption" {
  bucket = aws_s3_bucket.sclr_source.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.sclr_source_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

#destination Server side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "sclr_destination_encryption" {
  provider = aws.dr
  bucket   = aws_s3_bucket.sclr_destination.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.sclr_destination_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
}

resource "aws_kms_alias" "destination_alias" {
  provider      = aws.dr
  name          = "alias/s3-destination-key"
  target_key_id = aws_kms_key.sclr_destination_kms.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sclr_source_encryption" {
  bucket = aws_s3_bucket.sclr_source.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.sclr_source_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sclr_destination_encryption" {
  provider = aws.dr
  bucket   = aws_s3_bucket.sclr_destination.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.sclr_destination_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
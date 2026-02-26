data "aws_caller_identity" "current" {}

resource "aws_kms_key" "sclr_source_kms" {
  description         = "SCLR Source KMS Key"
  enable_key_rotation = true
}

resource "aws_kms_key" "sclr_destination_kms" {
  provider            = aws.dr
  description         = "SCLR Destination KMS Key"
  enable_key_rotation = true
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
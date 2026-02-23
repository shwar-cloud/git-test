# Source bucket
resource "aws_s3_bucket" "sclr_source" {
  bucket              = var.source_bucket_name
  object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "sclr_source_versioning" {
  bucket = aws_s3_bucket.sclr_source.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Source Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "sclr_source_encryption" {
  bucket = aws_s3_bucket.sclr_source.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.sclr_source_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
#Object lock
resource "aws_s3_bucket_object_lock_configuration" "sclr_object_lock" {
  bucket = aws_s3_bucket.sclr_source.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 7
    }
  }
}
#Source Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "sclr_lifecycle" {
  bucket = aws_s3_bucket.sclr_source.id

  rule {
    id     = "sclr-lifecycle-rule"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }
  }
}

# Destination bucket (DR region)
resource "aws_s3_bucket" "sclr_destination" {
  provider            = aws.dr
  bucket              = var.destination_bucket_name
  object_lock_enabled = true
}

#destination versioning
resource "aws_s3_bucket_versioning" "sclr_destination_versioning" {
  provider = aws.dr
  bucket   = aws_s3_bucket.sclr_destination.id

  versioning_configuration {
    status = "Enabled"
  }
}

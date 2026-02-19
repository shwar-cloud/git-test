##########################
# SOURCE BUCKET (source region)
##########################
resource "aws_s3_bucket" "source" {
  provider            = aws.source
  bucket              = var.source_bucket
  object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.source
  bucket   = aws_s3_bucket.source.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "source" {
  provider = aws.source
  bucket   = aws_s3_bucket.source.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 7
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source" {
  provider = aws.source
  bucket   = aws_s3_bucket.source.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.source_kms_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "source" {
  provider = aws.source
  bucket   = aws_s3_bucket.source.id

  rule {
    id     = "source-lifecycle"
    status = "Enabled"
    filter {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

##########################
# DESTINATION BUCKET (destination region)
##########################
resource "aws_s3_bucket" "destination" {
  provider            = aws.destination
  bucket              = var.destination_bucket
  object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "destination" {
  provider = aws.destination
  bucket   = aws_s3_bucket.destination.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "destination" {
  provider = aws.destination
  bucket   = aws_s3_bucket.destination.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 7
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "destination" {
  provider = aws.destination
  bucket   = aws_s3_bucket.destination.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.destination_kms_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

##########################
# REPLICATION CONFIGURATION (source region)
##########################
resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.source
  bucket   = aws_s3_bucket.source.id
  role     = var.replication_role_arn

  depends_on = [
    aws_s3_bucket_versioning.source,
    aws_s3_bucket_versioning.destination
  ]

  rule {
    id     = "replication-rule"
    status = "Enabled"
    filter {}

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = var.destination_kms_arn
      }
    }

    source_selection_criteria {
      sse_kms_encrypted_objects { status = "Enabled" }
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }
}

##########################
# REPLICATION FAILURE NOTIFICATION
##########################
resource "aws_s3_bucket_notification" "replication_failure" {
  provider = aws.source
  bucket   = aws_s3_bucket.source.id

  depends_on = [aws_s3_bucket_replication_configuration.replication]

  topic {
    topic_arn = var.sns_topic_arn
    events    = ["s3:Replication:OperationFailedReplication"]
  }
}

resource "aws_s3_bucket_replication_configuration" "sclr_replication" {
  bucket = aws_s3_bucket.sclr_source.id
  role   = aws_iam_role.sclr_replication_role.arn

  depends_on = [
    aws_s3_bucket_versioning.sclr_source_versioning,
    aws_s3_bucket_versioning.sclr_destination_versioning,
    aws_s3_bucket_server_side_encryption_configuration.sclr_source_encryption,
    aws_s3_bucket_server_side_encryption_configuration.sclr_destination_encryption
  ]

  rule {
    id     = "ReplicateKMSOnly"
    status = "Enabled"

    filter { 
      prefix = ""  # replicate all objects
    }

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket        = aws_s3_bucket.sclr_destination.arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = aws_kms_key.sclr_destination_kms.arn
      }

      # Enable replication metrics for CloudWatch
      metrics {
        status = "Enabled"
      }
    }

    # Replicate delete markers
    delete_marker_replication {
      status = "Enabled"
    }
  }
}   
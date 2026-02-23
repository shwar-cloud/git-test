resource "aws_s3_bucket_replication_configuration" "sclr_replication" {
  bucket = aws_s3_bucket.sclr_source.id
  role   = aws_iam_role.sclr_replication_role.arn
  depends_on = [
    aws_s3_bucket_versioning.source,
    aws_s3_bucket_versioning.destination,
    aws_s3_bucket_server_side_encryption_configuration.source_encryption,
    aws_s3_bucket_server_side_encryption_configuration.destination_encryption
  ]

rule {
    id     = "ReplicateKMSOnly"
    status = "Enabled"
    filter {
       prefix = "" # replicate all objects
    }

    # Only replicate KMS-encrypted objects
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
    } 
  }
} 

 

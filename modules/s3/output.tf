output "source_bucket_id" {
  value = aws_s3_bucket.sclr_source.id
}

output "destination_bucket_id" {
  value = aws_s3_bucket.sclr_destination.id
}

output "source_kms_key_arn" {
  value = aws_kms_key.sclr_source_kms.arn
}

output "destination_kms_key_arn" {
  value = aws_kms_key.sclr_destination_kms.arn
}
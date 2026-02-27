output "source_bucket" {
  value = aws_s3_bucket.sclr_source.bucket
}

output "destination_bucket" {
  value = aws_s3_bucket.sclr_destination.bucket
}


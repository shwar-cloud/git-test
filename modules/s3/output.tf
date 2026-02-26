output "source_bucket" {
<<<<<<< HEAD
  value = aws_s3_bucket.sclr_source.bucket
}

output "destination_bucket" {
  value = aws_s3_bucket.sclr_destination.bucket
}
=======
  value = aws_s3_bucket.source.bucket
}

output "destination_bucket" {
  value = aws_s3_bucket.destination.bucket
}
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765

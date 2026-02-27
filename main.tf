module "s3" {
  source = "./modules/s3"

  providers = {
    aws    = aws    # default provider (source bucket)
    aws.dr = aws.dr # alias provider (destination bucket)
  }

  source_region           = var.source_region
  destination_region      = var.destination_region
  source_bucket_name      = var.source_bucket_name
  destination_bucket_name = var.destination_bucket_name
}

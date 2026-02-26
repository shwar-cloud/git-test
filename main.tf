<<<<<<< HEAD
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
=======
#  S3 caller module

module "s3" {
  source = "./modules/s3"

 providers = {
    aws    = aws       # Default provider 
    aws.dr = aws.dr    # Alias provider 
  
  }

  source_bucket_name       = "sclrsourcebucket"
  destination_bucket_name  = "sclrdestinationbucket"
  source_region           = var.source_region
  destination_region      = var.destination_region
}
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765

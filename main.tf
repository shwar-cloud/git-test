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

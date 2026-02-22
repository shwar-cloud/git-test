# PROVIDERS

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "dr"
  region = "us-west-2"
}

#  S3 caller module

module "s3" {
  source = "./modules/s3"

  source_bucket_name       = "sclrsourcebucket"
  destination_bucket_name  = "sclrdestinationbucket"
  
  providers = {
    aws    = aws       # Default provider 
    aws.dr = aws.dr    # Alias provider 
  }
}
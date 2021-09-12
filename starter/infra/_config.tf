terraform {
  backend "s3" {
    bucket = "udacity-tf-emmanuel" # Update here with your S3 bucket
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = local.tags
  }
}
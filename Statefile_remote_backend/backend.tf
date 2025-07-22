terraform {
  backend "s3" {
    bucket = "prajwal-s3-bucket-bac"
    key    = "prajwal/terraform.tfstate"
    region = "us-east-1"
  }
}


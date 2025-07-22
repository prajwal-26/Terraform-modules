provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "prajwal" {
 ami = "ami-020cba7c55df1f615"
  instance_type ="t2.micro"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "prajwal-s3-bucket-xyz"
  
}

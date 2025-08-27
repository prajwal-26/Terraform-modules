variable "aws" {
  description = "aws region for server"
  default = "us-east-1"
}

variable "ec2_instance" {
  description = "instance image and size"
  default = {
    ami = "ami-0360c520857e3138f"
    instance_type = "t2.micro"
    key_name = "test"
  } 
}
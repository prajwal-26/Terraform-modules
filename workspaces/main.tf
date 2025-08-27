provider "aws" {
  region = "us-east-1"
}
variable "ami" {
  description = "ami"
}
variable "instance_type" {
  description = "instance type"
}
module "ec2_instance" {
  source = "./ec2_instance"
  ami = var.ami
  instance_type = var.instance_type
}
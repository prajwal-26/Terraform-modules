provider "aws" {
  region = var.aws
}

resource "aws_instance" "ec2" {
    ami = var.ec2_instance.ami
  instance_type = var.ec2_instance.instance_type
  key_name = var.ec2_instance.key_name
   tags = {
        Name = "ec2-instance"
   }
   
}

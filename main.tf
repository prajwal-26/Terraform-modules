module "ec2_instance" {
  source = "./ec2_module"
  ami_value = "ami-020cba7c55df1f615"
  instance_type_value="t2.micro"

}
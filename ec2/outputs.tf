output "ec2_details" {
  value ={
   private_instance_pubic_ip = aws_instance.ec2.public_ip
   private_instance_private_ip = aws_instance.ec2.private_ip
   public_pubic_ip =aws_instance.public_server.public_ip
   public_private_ip = aws_instance.public_server.private_ip
  } 
}
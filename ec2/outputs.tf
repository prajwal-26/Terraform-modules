output "ec2_details" {
  value ={
   pubic_ip = aws_instance.ec2.public_ip
   private-ip = aws_instance.ec2.private_ip
   
  } 
  
}
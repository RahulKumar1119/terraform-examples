output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.my-ec2-vm.public_ip
}

output "ec2_instance_privateip" {
  description = "EC2 Instance Private IP"
  value       = aws_instance.my-ec2-vm.private_ip
}

output "ec2_publicdns" {
  description = "Public DNS url of an EC2 instance"
  value       = "https://${aws_instance.my-ec2-vm.public_dns}"
}
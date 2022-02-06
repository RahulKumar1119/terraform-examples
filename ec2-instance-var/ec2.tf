resource "aws_instance" "my-ec2-vm" {
  ami           = var.ec2_ami_id
  instance_type = "t2.micro"
  key_name      = "rahul"
  count         = var.ec2_instance_count
  user_data     = file("apache_install.sh")

  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]

  tags = {
    "Name" = "myec2vm"
  }
}
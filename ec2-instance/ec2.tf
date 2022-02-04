resource "aws_instance" "my-ec2-vm" {
  ami                    = "ami-03fa4afc89e4a8a09"
  instance_type          = "t2.micro"
  availability_zone      = "ap-south-1a"
  key_name               = "rahul"
  subnet_id              = aws_subnet.vpc-dev-public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.vpc-dev-sg.id]
  user_data              = file("apache_install.sh")
  tags = {
    "Name" = "web"
  }
}
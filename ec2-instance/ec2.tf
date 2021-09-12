resource "aws_instance" "my-ec2-vm" {
  ami                    = "ami-0a23ccb2cdd9286bb"
  instance_type          = "t3a.small"
  key_name               = "rahul"
  subnet_id              = aws_subnet.vpc-dev-public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.dev-vpc-sg.id]
  user_data              = <<-EOF
        #! /bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        sudo service httpd start  
        sudo systemctl enable httpd
        #echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in us-east-1 Region</h1>" | sudo tee /var/www/html/index.html
        echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
    EOF
}
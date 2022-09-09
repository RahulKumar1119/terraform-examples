module "vpc" {
  source = "..//terraform-vpc-module"
}


resource "aws_security_group" "jenkins_server_sg" {
  name        = "jenkins_server_sg"
  description = "Security group for jenkins server"
  vpc_id      = element(module.vpc.vpc_id, 0)

  ingress {
    description = "Allow all traffic through port 8080"
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #   # Since we only want to be able to SSH into the Jenkins EC2 instance, we are only
  #   # allowing traffic from our IP on port 22
  ingress {
    description = "Allow SSH from my computer"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "jenkins-instance" {
  ami                    = var.ami
  subnet_id              = element(module.vpc.eks-vpc-public-subnet-1a_id, 0)
  instance_type          = var.instance-type
  key_name               = var.key-name
  user_data              = file("./install_jenkins.sh")
  vpc_security_group_ids = ["${aws_security_group.jenkins_server_sg.id}"]

  tags = {
    Name = "jenkins_server"
  }
}


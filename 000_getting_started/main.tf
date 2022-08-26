terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

variable "instance_type" {
  type = string
}

locals {
  project_name = "5to7"
}

resource "aws_instance" "my_server" {
  ami           = "ami-07eaf27c7c4a884cf"
  instance_type = var.instance_type
  key_name      = "rahul"

  tags = {
    Name = "my-server-${local.project_name}"
  }
}

output "instance_public_ip" {
  value = aws_instance.my_server.public_ip
}

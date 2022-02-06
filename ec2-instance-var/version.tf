terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.29.1"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
} 
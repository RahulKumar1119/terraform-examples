terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.29.1"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "default"
} 
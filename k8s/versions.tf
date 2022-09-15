terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74"
    }


    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.5.1"
    }
  }

  required_version = ">= 0.13"
}

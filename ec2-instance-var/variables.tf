variable "aws_region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "ap-south-1"
}

variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-03fa4afc89e4a8a09"
}

variable "ec2_instance_count" {
  description = "EC2 instance count"
  type        = number
  default     = 1
}
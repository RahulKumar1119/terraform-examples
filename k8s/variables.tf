variable "region" {
  type        = string
  description = "Region of VPC"
  default     = "ap-south-1"
}

variable "profile" {
  type        = string
  description = "(optional) describe your variable"
  default     = "default"
}

variable "ami" {
  type        = string
  description = "ami of jenkins instance"
  default     = "ami-07eaf27c7c4a884cf"
}

variable "instance-type" {
  type        = string
  description = "type of instance"
  default     = "t3a.small"
}

variable "key-name" {
  type        = string
  description = "ssh key name"
  default     = "rahul"
}

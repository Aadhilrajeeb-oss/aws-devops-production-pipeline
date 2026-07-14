variable "aws_region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "devops-assignment"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "instance_type" {
  default = "t2.micro" # Free tier eligible
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
}

variable "my_ip" {
  description = "Your IP address in CIDR form, e.g. 1.2.3.4/32 - for SSH access only"
  type        = string
}

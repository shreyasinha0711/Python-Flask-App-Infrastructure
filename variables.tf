variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "192.168.0.0/16"
}
variable "cidr_subnet_public" {
  description = "CIDR block for the subnet"
  default     = "192.168.0.0/24"
}
variable "cidr_subnet_private" {
  description = "CIDR block for the subnet"
  default     = "192.168.1.0/24"
}

variable "availability_zone_public" {
  description = "availability zone to create subnet"
  default     = "ap-south-1a"
}
variable "availability_zone_private" {
  description = "availability zone to create subnet"
  default     = "ap-south-1b"
}

variable "key_name" {
  description = "ec2 key name"
  default     = "ec2Key"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default     = "ami-0c1a7f89451184c8b"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "Development"
}

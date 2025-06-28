variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "ssh_access_cidr" {
  description = "CIDR block for SSH access to bastion"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "main"
}
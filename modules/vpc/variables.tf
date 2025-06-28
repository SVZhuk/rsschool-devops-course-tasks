variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
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

variable "nat_ami_id" {
  description = "AMI ID for NAT instance"
  type        = string
}

variable "nat_instance_type" {
  description = "Instance type for NAT instance"
  type        = string
  default     = "t2.micro"
}

variable "nat_sg_id" {
  description = "Security group ID for NAT instance"
  type        = string
  default     = "sg-placeholder"
}
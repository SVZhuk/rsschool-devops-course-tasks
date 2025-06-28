variable "amazon_linux_ami_id" {
  description = "AMI ID for Amazon Linux"
  type        = string
}

variable "instance_type_bastion" {
  description = "Instance type for bastion hosts"
  type        = string
  default     = "t2.micro"
}

variable "instance_type_private" {
  description = "Instance type for private instances"
  type        = string
  default     = "t2.micro"
}

variable "instance_type_public" {
  description = "Instance type for public instances"
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_ids" {
  description = "IDs of public subnets"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs of private subnets"
  type        = list(string)
}

variable "bastion_sg_id" {
  description = "ID of bastion security group"
  type        = string
}

variable "private_sg_id" {
  description = "ID of private security group"
  type        = string
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
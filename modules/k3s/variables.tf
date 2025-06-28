variable "amazon_linux_ami_id" {
  description = "AMI ID for Amazon Linux"
  type        = string
}

variable "k3s_master_instance_type" {
  description = "Instance type for K3s master node"
  type        = string
  default     = "t2.micro"
}

variable "k3s_worker_instance_type" {
  description = "Instance type for K3s worker node"
  type        = string
  default     = "t2.micro"
}

variable "private_subnet_ids" {
  description = "IDs of private subnets"
  type        = list(string)
}

variable "k3s_sg_id" {
  description = "Security group ID for K3s nodes"
  type        = string
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
}

variable "k3s_token" {
  description = "K3s cluster token"
  type        = string
  sensitive   = true
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
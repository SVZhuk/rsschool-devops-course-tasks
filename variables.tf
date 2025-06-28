variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "rs-devops-tf-state"
}

variable "github_repository" {
  description = "GitHub repository for CI/CD"
  type        = string
  default     = "SVZhuk/rsschool-devops-course-tasks"
}

variable "key_pair_name" {
  description = "Name of the AWS key pair for EC2 instances"
  type        = string
  default     = null
}

variable "my_ip_address" {
  description = "IP address for SSH access to bastion host (CIDR format)"
  type        = string
  default     = "0.0.0.0/0"
  validation {
    condition     = can(cidrnetmask(var.my_ip_address))
    error_message = "The my_ip_address value must be a valid CIDR block, e.g. 1.2.3.4/32"
  }
}

variable "instance_type_nat" {
  description = "Instance type for NAT instance"
  type        = string
  default     = "t2.micro"
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

variable "k3s_token" {
  description = "K3s cluster token"
  type        = string
  default     = "my-k3s-token-12345"
  sensitive   = true
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
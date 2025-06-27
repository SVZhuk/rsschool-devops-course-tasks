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
    condition     = can(regex("^([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,2})$", var.my_ip_address))
    error_message = "The my_ip_address value must be a valid CIDR block, e.g. 1.2.3.4/32"
  }
}

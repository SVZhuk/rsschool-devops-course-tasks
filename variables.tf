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
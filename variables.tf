variable "vault_address" {
  description = "Local server address for Vault"
  type        = string
  default     = "http://localhost:8200"
}

variable "vault_token" {
  description = "Vault authentication token"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
  default     = "rs-devops-terraform-bucket"
}

data "vault_kv_secret_v2" "aws_credentials" {
  mount = "secret"
  name  = "aws"
}

variable "bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "rs-devops-tf-state"
}
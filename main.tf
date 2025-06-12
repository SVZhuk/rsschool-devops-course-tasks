resource "aws_s3_bucket" "state_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "DevOps"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


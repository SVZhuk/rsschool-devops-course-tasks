# Resources for remote state
resource "aws_s3_bucket" "bootstrap_state_bucket" {
  bucket = "rs-devops-tf-state"
  tags = {
    Project     = "rsschool-devops"
    Environment = "devops"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "bootstrap_versioning" {
  bucket = aws_s3_bucket.bootstrap_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bootstrap_encryption" {
  bucket = aws_s3_bucket.bootstrap_state_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "bootstrap_lock_table" {
  name         = "rs-devops-tf-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Project     = "rsschool-devops"
    Environment = "devops"
    ManagedBy   = "terraform"
  }
}
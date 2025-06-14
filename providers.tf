terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "rs-devops-tf-state"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "rs-devops-tf-state-lock"
    use_lockfile   = true
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

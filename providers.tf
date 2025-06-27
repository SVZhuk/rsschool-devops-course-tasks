terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }

  # Backend configuration without hardcoded values
  # This allows using -backend-config flags
  backend "s3" {}

  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

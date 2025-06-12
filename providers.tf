terraform {
  required_providers {
    aws = {
      # specify plugin source and version for AWS provider
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    vault = {
      # specify plugin source and version for Vault provider
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }

  # specify Terraform version constraints
  required_version = ">= 1.0"
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

provider "aws" {
  region     = var.aws_region
  access_key = data.vault_kv_secret_v2.aws_credentials.data["access_key"]
  secret_key = data.vault_kv_secret_v2.aws_credentials.data["secret_key"]
}

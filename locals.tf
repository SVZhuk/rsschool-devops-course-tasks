locals {
  common_tags = {
    Project     = "rsschool-devops"
    Environment = "devops"
    ManagedBy   = "terraform"
    Repository  = var.github_repository
  }

  aws_managed_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ]

  dynamodb_table_name = "${var.bucket_name}-lock"
  github_role_name    = "GitHubActionsRole"

}
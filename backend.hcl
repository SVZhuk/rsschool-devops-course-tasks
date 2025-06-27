bucket         = "rs-devops-tf-state"
key            = "state/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "rs-devops-tf-state-lock"
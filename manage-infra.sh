#!/bin/bash

function usage {
  echo "Usage: $0 [up|down|init|local|remote|bootstrap]"
  echo "  up        - Create or update infrastructure"
  echo "  down      - Destroy infrastructure"
  echo "  init      - Initialize or reinitialize Terraform"
  echo "  local     - Switch to local state"
  echo "  remote    - Switch to remote state"
  echo "  bootstrap - Create S3 bucket and DynamoDB table for remote state"
  exit 1
}

if [ $# -ne 1 ]; then
  usage
fi

case "$1" in
  up)
    echo "Creating infrastructure..."
    terraform apply -auto-approve -lock=false
    echo "Infrastructure is ready!"
    if terraform output -raw ssh_command &>/dev/null; then
      echo "SSH command: $(terraform output -raw ssh_command)"
    fi
    ;;
  down)
    echo "Destroying infrastructure..."
    terraform destroy -auto-approve -lock=false
    echo "Infrastructure destroyed."
    ;;
  init)
    echo "Initializing Terraform..."
    terraform init
    echo "Terraform initialized."
    ;;
  local)
    echo "Switching to local state..."
    terraform init -migrate-state -backend=false
    echo "Now using local state."
    ;;
  remote)
    echo "Switching to remote state..."
    terraform init -migrate-state -backend-config=backend.hcl -lock=false
    echo "Now using remote state in S3."
    ;;
  bootstrap)
    echo "Creating remote state resources..."
    
    # Use the dedicated bootstrap directory
    cd bootstrap
    
    # Initialize and apply
    terraform init -reconfigure
    
    # Try to import existing resources first
    echo "Checking for existing resources..."
    terraform import aws_s3_bucket.bootstrap_state_bucket rs-devops-tf-state 2>/dev/null || true
    terraform import aws_dynamodb_table.bootstrap_lock_table rs-devops-tf-state-lock 2>/dev/null || true
    
    # Apply with error handling
    terraform apply -auto-approve || {
      echo "Some resources may already exist. This is usually not a problem."
    }
    
    cd ..
    
    echo "Remote state resources created. You can now use './manage-infra.sh remote'"
    ;;
  *)
    usage
    ;;
esac
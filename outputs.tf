output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "nat_instance_id" {
  description = "ID of the NAT instance"
  value       = module.vpc.nat_instance_id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.instances.bastion_public_ip
}

output "ssh_command" {
  description = "SSH command to connect to bastion host"
  value       = module.instances.ssh_command
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.state.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.state.s3_bucket_arn
}
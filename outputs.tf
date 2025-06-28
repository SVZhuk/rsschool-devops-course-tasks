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

output "k3s_master_private_ip" {
  description = "Private IP of K3s master node"
  value       = module.k3s.k3s_master_private_ip
}

output "k3s_worker_private_ip" {
  description = "Private IP of K3s worker node"
  value       = module.k3s.k3s_worker_private_ip
}

output "k3s_ssh_commands" {
  description = "SSH commands to connect to K3s nodes via bastion"
  value = {
    master = "ssh -i .ssh/bastion-key.pem -J ec2-user@${module.instances.bastion_public_ip} ec2-user@${module.k3s.k3s_master_private_ip}"
    worker = "ssh -i .ssh/bastion-key.pem -J ec2-user@${module.instances.bastion_public_ip} ec2-user@${module.k3s.k3s_worker_private_ip}"
  }
}
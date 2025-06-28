output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  description = "ID of the bastion instance"
  value       = aws_instance.bastion.id
}

# Removed outputs for deleted instances

output "ssh_command" {
  description = "SSH command to connect to bastion host"
  value       = "ssh -i .ssh/bastion-key.pem ec2-user@${aws_instance.bastion.public_ip}"
}

output "key_name" {
  description = "Name of the AWS key pair"
  value       = aws_key_pair.bastion.key_name
}
output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  description = "ID of the bastion instance"
  value       = aws_instance.bastion.id
}

output "private_az1_instance_id" {
  description = "ID of the private AZ1 instance"
  value       = aws_instance.private_az1.id
}

output "public_az2_instance_id" {
  description = "ID of the public AZ2 instance"
  value       = aws_instance.public_az2.id
}

output "private_az2_instance_id" {
  description = "ID of the private AZ2 instance"
  value       = aws_instance.private_az2.id
}

output "ssh_command" {
  description = "SSH command to connect to bastion host"
  value       = "ssh -i .ssh/bastion-key.pem ec2-user@${aws_instance.bastion.public_ip}"
}
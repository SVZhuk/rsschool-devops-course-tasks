output "bastion_sg_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}

output "private_sg_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private.id
}

output "web_sg_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "nat_instance_sg_id" {
  description = "ID of the NAT instance security group"
  value       = aws_security_group.nat_instance.id
}

output "all_security_group_ids" {
  description = "Map of all security group IDs"
  value = {
    bastion      = aws_security_group.bastion.id
    private      = aws_security_group.private.id
    web          = aws_security_group.web.id
    nat_instance = aws_security_group.nat_instance.id
  }
}
output "k3s_master_private_ip" {
  description = "Private IP of K3s master node"
  value       = aws_instance.k3s_master.private_ip
}

output "k3s_worker_private_ip" {
  description = "Private IP of K3s worker node"
  value       = aws_instance.k3s_worker.private_ip
}

output "k3s_master_instance_id" {
  description = "Instance ID of K3s master node"
  value       = aws_instance.k3s_master.id
}

output "k3s_worker_instance_id" {
  description = "Instance ID of K3s worker node"
  value       = aws_instance.k3s_worker.id
}
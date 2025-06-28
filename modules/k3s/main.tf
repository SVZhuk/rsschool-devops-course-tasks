# K3s Master Node
resource "aws_instance" "k3s_master" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.k3s_master_instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.k3s_sg_id]
  key_name               = var.key_name

  user_data = base64encode(templatefile("${path.module}/scripts/k3s-master.sh", {
    k3s_token = var.k3s_token
  }))

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-k3s-master"
    Role = "k3s-master"
  })
}

# K3s Worker Node
resource "aws_instance" "k3s_worker" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.k3s_worker_instance_type
  subnet_id              = var.private_subnet_ids[1]
  vpc_security_group_ids = [var.k3s_sg_id]
  key_name               = var.key_name

  user_data = base64encode(templatefile("${path.module}/scripts/k3s-worker.sh", {
    k3s_token     = var.k3s_token
    k3s_master_ip = aws_instance.k3s_master.private_ip
  }))

  depends_on = [aws_instance.k3s_master]

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-k3s-worker"
    Role = "k3s-worker"
  })
}
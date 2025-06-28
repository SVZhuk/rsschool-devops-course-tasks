resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
  
  lifecycle {
    # Generate a new key on every apply
    ignore_changes = []
  }
}

resource "aws_key_pair" "bastion" {
  key_name   = "${var.name_prefix}-key"
  public_key = tls_private_key.ssh.public_key_openssh
  tags       = var.common_tags
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.root}/.ssh/bastion-key.pem"
  file_permission = "0600"
  
  provisioner "local-exec" {
    command = "mkdir -p ${path.root}/.ssh && chmod 700 ${path.root}/.ssh"
  }
}

resource "aws_instance" "bastion" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.instance_type_bastion
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = aws_key_pair.bastion.key_name

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-bastion"
  })
}

resource "aws_instance" "private_az1" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.instance_type_private
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = aws_key_pair.bastion.key_name

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-private-az1"
  })
}

resource "aws_instance" "public_az2" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.instance_type_public
  subnet_id              = var.public_subnet_ids[1]
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = aws_key_pair.bastion.key_name

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-public-az2"
  })
}

resource "aws_instance" "private_az2" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.instance_type_private
  subnet_id              = var.private_subnet_ids[1]
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = aws_key_pair.bastion.key_name

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-private-az2"
  })
}
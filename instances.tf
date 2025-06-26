resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags                   = merge(local.common_tags, { Name = "bastion-az1" })
}

resource "aws_instance" "private_az1" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.private.id]
  tags                   = merge(local.common_tags, { Name = "private-az1" })
}

resource "aws_instance" "public_az2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[1].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags                   = merge(local.common_tags, { Name = "public-az2" })
}

resource "aws_instance" "private_az2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private[1].id
  vpc_security_group_ids = [aws_security_group.private.id]
  tags                   = merge(local.common_tags, { Name = "private-az2" })
}
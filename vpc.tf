data "aws_availability_zones" "available" {
  state = "available"
}

# NAT instance AMI
data "aws_ami" "nat_instance" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
  Name = "main-vpc" })
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
  Name = "main-igw" })
}

# public subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "public-subnet-${count.index + 1}"
    Type = "Public"
  })
}

# private subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.common_tags, {
    Name = "private-subnet-${count.index + 1}"
    Type = "Private"
  })
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = "public-rt" })

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# public route table association
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security group for NAT instance
resource "aws_security_group" "nat_instance" {
  name_prefix = "nat-instance-"
  vpc_id      = aws_vpc.main.id

  # allow http traffic from private subnets
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [for subnet in aws_subnet.private : subnet.cidr_block]
  }

  # allow https traffic from private subnets
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [for subnet in aws_subnet.private : subnet.cidr_block]
  }

  # ssh from bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  # allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "nat-instance-sg" })
}

# NAT instance in AZ1 public
resource "aws_instance" "nat_instance" {
  ami                    = data.aws_ami.nat_instance.id
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.nat_instance.id]
  key_name               = var.key_pair_name
  source_dest_check      = false

  tags = merge(local.common_tags, {
    Name = "nat-instance-az1"
    Type = "NAT"
  })

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y iptables-services
              echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
              sysctl -p
              /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              /sbin/iptables -F FORWARD
              /sbin/iptables -A FORWARD -i eth0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
              /sbin/iptables -A FORWARD -i eth0 -o eth0 -j ACCEPT
              service iptables save
              systemctl enable iptables
              echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.d/custom-ip-forwarding.conf
              EOF
  )
}

# private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = "private-rt" })

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_instance.primary_network_interface_id
  }
}

# private route table association
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
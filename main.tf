# Data sources moved to data.tf

# Create VPC first
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = data.aws_availability_zones.available.names
  common_tags          = local.common_tags
  name_prefix          = "main"
  nat_ami_id           = data.aws_ami.nat_instance.id
  nat_instance_type    = var.instance_type_nat
  nat_sg_id            = "sg-placeholder" # Will be updated after security group creation
}

# Then create security groups
module "security" {
  source = "./modules/security"

  vpc_id               = module.vpc.vpc_id
  vpc_cidr             = module.vpc.vpc_cidr
  ssh_access_cidr      = var.my_ip_address
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  common_tags          = local.common_tags
  name_prefix          = "main"

  depends_on = [module.vpc]
}

module "instances" {
  source = "./modules/instances"

  amazon_linux_ami_id   = data.aws_ami.amazon_linux.id
  instance_type_bastion = var.instance_type_bastion
  instance_type_private = var.instance_type_private
  instance_type_public  = var.instance_type_public
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  bastion_sg_id         = module.security.bastion_sg_id
  private_sg_id         = module.security.private_sg_id
  common_tags           = local.common_tags
  name_prefix           = "main"

  depends_on = [module.vpc]
}

module "state" {
  source = "./modules/state"

  bucket_name = var.bucket_name
}
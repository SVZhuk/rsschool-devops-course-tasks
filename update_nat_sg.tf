# This resource is used to update the NAT instance security group after both modules are created
resource "aws_security_group_rule" "nat_instance_sg_update" {
  security_group_id = module.security.nat_instance_sg_id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all inbound traffic (added after module creation)"

  depends_on = [module.security, module.vpc]
}
resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-bastion-sg"
  description = "Bastion host - SSH allowed only from the admin IP"
  vpc_id      = aws_vpc.main.id

  tags = { Name = "${local.name_prefix}-bastion-sg" }
}

resource "aws_security_group" "private_vm" {
  name        = "${local.name_prefix}-private-vm-sg"
  description = "Private VM - SSH allowed only from the bastion SG"
  vpc_id      = aws_vpc.main.id

  tags = { Name = "${local.name_prefix}-private-vm-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh_from_admin" {
  security_group_id = aws_security_group.bastion.id
  description       = "SSH from the admin IP only"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.admin_ip_cidr
}

resource "aws_vpc_security_group_egress_rule" "bastion_ssh_to_private" {
  security_group_id            = aws_security_group.bastion.id
  description                  = "SSH to private VMs only"
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = aws_security_group.private_vm.id
}

resource "aws_vpc_security_group_egress_rule" "bastion_https_updates" {
  security_group_id = aws_security_group.bastion.id
  description       = "HTTPS outbound for OS updates"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "private_ssh_from_bastion" {
  security_group_id            = aws_security_group.private_vm.id
  description                  = "SSH from the bastion only"
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = aws_security_group.bastion.id
}

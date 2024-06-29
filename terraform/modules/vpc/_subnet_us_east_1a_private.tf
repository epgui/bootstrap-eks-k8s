# ---------------------------------------------------------------------------- #
# Private Route Table
# ---------------------------------------------------------------------------- #

resource "aws_route_table" "us_east_1a_private" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name} - us_east_1a_private"
  }
}

resource "aws_route_table_association" "us_east_1a_private_subnet" {
  subnet_id      = aws_subnet.us_east_1a_private.id
  route_table_id = aws_route_table.us_east_1a_private.id
}

resource "aws_route" "us_east_1a_private_nat_gateway" {
  route_table_id         = aws_route_table.us_east_1a_private.id
  destination_cidr_block = local.all_ip_cidr_block
  nat_gateway_id         = aws_nat_gateway.eks_cluster_nat_gateway.id
}

# ---------------------------------------------------------------------------- #
# Network ACL
# ---------------------------------------------------------------------------- #

resource "aws_network_acl" "us_east_1a_private" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name} - us_east_1a_private_nacl"
  }
}

resource "aws_network_acl_association" "us_east_1a_private_subnet" {
  network_acl_id = aws_network_acl.us_east_1a_private.id
  subnet_id      = aws_subnet.us_east_1a_private.id
}

resource "aws_network_acl_rule" "us_east_1a_private_allow_all_egress" {
  network_acl_id = aws_network_acl.us_east_1a_private.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = local.all_ip_cidr_block
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "us_east_1a_private_allow_all_ingress" {
  network_acl_id = aws_network_acl.us_east_1a_private.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = local.all_ip_cidr_block
  from_port      = 0
  to_port        = 0
}

# ---------------------------------------------------------------------------- #
# Private Subnet
# ---------------------------------------------------------------------------- #

resource "aws_subnet" "us_east_1a_private" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "us-east-1a"
  cidr_block                                     = "172.31.96.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = true
  private_dns_hostname_type_on_launch            = "ip-name"
  vpc_id                                         = aws_vpc.this.id
  tags = {
    "Name"                                          = "${var.vpc_name} - us_east_1a_private"
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

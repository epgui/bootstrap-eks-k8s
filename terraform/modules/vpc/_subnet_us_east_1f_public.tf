# ---------------------------------------------------------------------------- #
# Public Route Table
# ---------------------------------------------------------------------------- #

resource "aws_route_table" "us_east_1f_public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name} - us_east_1f_public"
  }
}

resource "aws_route_table_association" "us_east_1f_public_subnet" {
  subnet_id      = aws_subnet.us_east_1f_public.id
  route_table_id = aws_route_table.us_east_1f_public.id
}

# This is what makes the route table (and its associated subnet) "public"
resource "aws_route" "us_east_1f_public_internet_gateway" {
  route_table_id         = aws_route_table.us_east_1f_public.id
  destination_cidr_block = local.all_ip_cidr_block
  gateway_id             = aws_internet_gateway.this.id
}

# ---------------------------------------------------------------------------- #
# Network ACL
# ---------------------------------------------------------------------------- #

resource "aws_network_acl" "us_east_1f_public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name} - us_east_1f_public_nacl"
  }
}

resource "aws_network_acl_association" "us_east_1f_public_subnet" {
  network_acl_id = aws_network_acl.us_east_1f_public.id
  subnet_id      = aws_subnet.us_east_1f_public.id
}

resource "aws_network_acl_rule" "us_east_1f_public_allow_all_egress" {
  network_acl_id = aws_network_acl.us_east_1f_public.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = local.all_ip_cidr_block
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "us_east_1f_public_allow_all_ingress" {
  network_acl_id = aws_network_acl.us_east_1f_public.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = local.all_ip_cidr_block
  from_port      = 0
  to_port        = 0
}

# ---------------------------------------------------------------------------- #
# Public Subnet
# ---------------------------------------------------------------------------- #

resource "aws_subnet" "us_east_1f_public" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "us-east-1f"
  cidr_block                                     = "172.31.64.0/20"
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = true
  private_dns_hostname_type_on_launch            = "ip-name"
  vpc_id                                         = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name} - us_east_1f_public"
  }
}

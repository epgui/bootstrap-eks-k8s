resource "aws_default_vpc_dhcp_options" "this" {
  tags = {
    Name = "${var.vpc_name} - Default DHCP Option Set"
  }
}

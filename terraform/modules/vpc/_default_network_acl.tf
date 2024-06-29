resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
  tags = {
    Name = "${var.vpc_name} - Default Network ACL (No Access)"
  }
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

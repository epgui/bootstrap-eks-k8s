resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  tags = {
    Name = "${var.vpc_name} - Default Route Table (No Routes)"
  }
}

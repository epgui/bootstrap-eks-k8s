resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name} - Default Security Group (No Access)"
  }
}

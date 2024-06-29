output "default_network_acl_id" {
  value = aws_default_network_acl.this.id
}

output "default_route_table_id" {
  value = aws_default_route_table.this.id
}

output "default_security_group_id" {
  value = aws_default_security_group.this.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "private_subnet_ids" {
  value = {
    us_east_1a_private = aws_subnet.us_east_1a_private.id,
    us_east_1b_private = aws_subnet.us_east_1b_private.id,
    us_east_1c_private = aws_subnet.us_east_1c_private.id,
    us_east_1d_private = aws_subnet.us_east_1d_private.id,
    us_east_1e_private = aws_subnet.us_east_1e_private.id,
    us_east_1f_private = aws_subnet.us_east_1f_private.id,
  }
}

output "public_subnet_ids" {
  value = {
    us_east_1a_public = aws_subnet.us_east_1a_public.id,
    us_east_1b_public = aws_subnet.us_east_1b_public.id,
    us_east_1c_public = aws_subnet.us_east_1c_public.id,
    us_east_1d_public = aws_subnet.us_east_1d_public.id,
    us_east_1e_public = aws_subnet.us_east_1e_public.id,
    us_east_1f_public = aws_subnet.us_east_1f_public.id,
  }
}

output "vpc_id" {
  value = aws_vpc.this.id
}
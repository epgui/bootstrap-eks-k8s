terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

locals {
  all_ip_cidr_block = "0.0.0.0/0"
  vpc_ip_cidr_block = "172.31.0.0/16"
}

resource "aws_vpc" "this" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = local.vpc_ip_cidr_block
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  tags = {
    Name = var.vpc_name
  }
}

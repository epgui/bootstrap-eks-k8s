terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

data "aws_subnets" "eks_cluster" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }
}

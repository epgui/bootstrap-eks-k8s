# Note: Availability can be improved by giving each subnet its own NAT Gateway.
data "aws_subnet" "eks_cluster_nat_gateway" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.this.id]
  }
  filter {
    name   = "tag:HasEksNatGateway"
    values = ["True"]
  }
}

# Pricing: https://aws.amazon.com/vpc/pricing/
#   - $0.005 per hour or ~$3.75 per month, whether or not it's in use.
resource "aws_eip" "eks_cluster_nat_gateway" {
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name} - NAT Gateway EIP"
  }
}

# Pricing: https://aws.amazon.com/vpc/pricing/
#  - $0.045 per hour or ~$35 per month
#  - $0.045 per GB of bandwidth
resource "aws_nat_gateway" "eks_cluster_nat_gateway" {
  allocation_id = aws_eip.eks_cluster_nat_gateway.id
  subnet_id     = data.aws_subnet.eks_cluster_nat_gateway.id
  depends_on    = [aws_internet_gateway.this]
}

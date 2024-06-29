data "aws_iam_policy_document" "eks_cluster__assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  path               = var.aws_iam_path
  name               = var.aws_iam_role_cluster_name
  assume_role_policy = data.aws_iam_policy_document.eks_cluster__assume_role.json
}

# NOTE: This can be tightened down significantly, as all the load balancer
# permissions (which comprise nearly half of the policy document) are legacy.
# Ref: https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
resource "aws_iam_role_policy_attachment" "eks_cluster__amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster__amazon_eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}

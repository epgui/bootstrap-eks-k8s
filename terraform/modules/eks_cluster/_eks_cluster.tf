# Pricing: https://aws.amazon.com/eks/pricing/
#   - $0.10 per hour, or around $75 per month.
#   - Other resources consumed (eg.: EC2 for provisioned nodes) are charged
#     separately
resource "aws_eks_cluster" "this" {
  name     = var.eks_cluster_name
  version  = var.aws_kubernetes_version
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    # Subnet IDs for the worker nodes. The provided subnets must span at least
    # two AZs. EKS will create cross-account Elastic Network Interfaces in these
    # subnets to allow communication between the worker nodes and the k8s
    # control plane.
    #
    # See also:
    # - https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
    subnet_ids = data.aws_subnets.eks_cluster.ids
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster__amazon_eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_cluster__amazon_eks_vpc_resource_controller,
  ]
}

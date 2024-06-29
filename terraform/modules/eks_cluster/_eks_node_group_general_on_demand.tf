resource "aws_eks_node_group" "general_on_demand" {
  cluster_name    = aws_eks_cluster.this.name
  version         = var.aws_kubernetes_version
  node_group_name = "${var.eks_cluster_name}__node_group_general_on_demand"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = data.aws_subnets.eks_cluster.ids

  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3a.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general_on_demand"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group__amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_node_group__amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.eks_node_group__amazon_ec2_container_registry_readonly,
  ]

  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

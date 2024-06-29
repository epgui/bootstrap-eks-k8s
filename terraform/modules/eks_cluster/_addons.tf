locals {
  # To view available versions, run:
  #
  # ```bash
  # aws eks describe-addon-versions --region us-east-1 --addon-name eks-pod-identity-agent
  # ```
  eks_pod_identity_agent_version = "v1.3.0-eksbuild.1"
}

# The eks-pod-identity-agent is free to run.
resource "aws_eks_addon" "pod_identity" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = local.eks_pod_identity_agent_version
}

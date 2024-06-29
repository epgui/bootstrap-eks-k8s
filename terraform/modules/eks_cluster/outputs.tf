output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane, used to configure kubectl."
  value       = aws_eks_cluster.this.endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the cluster control plane, used to configure kubectl."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "eks_cluster_name" {
  description = "Kubernetes cluster name, used to configure kubectl."
  value       = aws_eks_cluster.this.name
}

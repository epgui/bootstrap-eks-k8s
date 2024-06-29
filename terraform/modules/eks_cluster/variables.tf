variable "aws_account_id" {
  sensitive = false
  type      = string
}

variable "aws_iam_path" {
  sensitive = false
  type      = string
}

variable "aws_iam_path_k8s_rbac" {
  sensitive = false
  type      = string
}

variable "aws_iam_role_cluster_name" {
  sensitive = false
  type      = string
}

variable "aws_iam_role_k8s_aws_load_balancer_controller" {
  sensitive = false
  type      = string
}

variable "aws_iam_role_k8s_cluster_autoscaler" {
  sensitive = false
  type      = string
}

variable "aws_iam_role_k8s_rbac_group_admin" {
  sensitive = false
  type      = string
}

variable "aws_iam_role_k8s_rbac_group_viewer" {
  sensitive = false
  type      = string
}

variable "aws_iam_role_node_group_name" {
  sensitive = false
  type      = string
}

variable "aws_kubernetes_version" {
  sensitive = false
  type      = string
}

variable "aws_region" {
  sensitive = false
  type      = string
}

variable "eks_cluster_name" {
  sensitive = false
  type      = string
}

variable "environment" {
  sensitive = false
  type      = string
}

variable "rbac_group_admin" {
  sensitive = false
  type      = string
}

variable "rbac_group_viewer" {
  sensitive = false
  type      = string
}

variable "service_account_cluster_autoscaler" {
  sensitive = false
  type      = string
}

variable "service_account_aws_load_balancer_controller" {
  sensitive = false
  type      = string
}

variable "vpc_id" {
  sensitive = false
  type      = string
}

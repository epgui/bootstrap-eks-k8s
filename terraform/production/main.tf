terraform {
  backend "s3" {
    # NOTE: these need to be hardcoded.
    bucket         = "my-state"
    key            = "my-cluster/production.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my_state_locks"
    encrypt        = true
  }
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws",
      version = "5.55.0"
    }
  }
  # terraform version
  required_version = "1.8.5"
}

provider "aws" {
  alias  = "aws_us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Environment          = "Production"
      Managed-By-Terraform = "True"
      Responsible-Team     = "My Team"
      Source-Repository    = "https://github.com/epgui/bootstrap-eks-k8s"
    }
  }
}

locals {
  environment      = "production"
  eks_cluster_name = "my_cluster"
}

data "aws_caller_identity" "this" {}

module "terraform_state" {
  source    = "../modules/state"
  providers = { aws = aws.aws_us_east_1 }

  # NOTE: These must match the values hardcoded in the terraform backend block.
  s3_bucket      = "my-state"
  dynamodb_table = "my_state_locks"
}

# Note EKS requirements for VPC and Subnets:
# - https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
module "my_vpc" {
  source           = "../modules/vpc"
  providers        = { aws = aws.aws_us_east_1 }
  eks_cluster_name = local.eks_cluster_name
  environment      = local.environment
  vpc_name         = "My VPC"
}

# References
# - https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
# - https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
# - https://aws.amazon.com/blogs/containers/amazon-eks-cluster-multi-zone-auto-scaling-groups/
module "my_eks_cluster" {
  source                 = "../modules/eks_cluster"
  providers              = { aws = aws.aws_us_east_1 }
  aws_account_id         = data.aws_caller_identity.this.account_id
  aws_kubernetes_version = "1.30"
  aws_region             = "us-east-1"
  environment            = local.environment
  eks_cluster_name       = local.eks_cluster_name
  vpc_id                 = module.my_vpc.vpc_id

  # IAM EKS
  aws_iam_path                 = "/MyCluster/"
  aws_iam_role_cluster_name    = "MyCluster"
  aws_iam_role_node_group_name = "MyCluster-MyNodeGroup"

  # IAM Kubernetes
  aws_iam_path_k8s_rbac                         = "/MyCluster/KubernetesRbac/"
  aws_iam_role_k8s_aws_load_balancer_controller = "MyCluster-AwsLoadBalancerController"
  aws_iam_role_k8s_cluster_autoscaler           = "MyCluster-ClusterAutoscaler"
  aws_iam_role_k8s_rbac_group_admin             = "MyCluster-RBAC-KubernetesAdmin"
  aws_iam_role_k8s_rbac_group_viewer            = "MyCluster-RBAC-KubernetesViewer"
  rbac_group_admin                              = "eks-admin"
  rbac_group_viewer                             = "eks-viewer"
  service_account_cluster_autoscaler            = "cluster-autoscaler"
  service_account_aws_load_balancer_controller  = "aws-load-balancer-controller"
}

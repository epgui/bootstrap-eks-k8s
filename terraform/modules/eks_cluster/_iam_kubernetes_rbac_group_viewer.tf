# ---------------------------------------------------------------------------- #
# IAM Group
# ---------------------------------------------------------------------------- #

data "aws_iam_policy_document" "rbac_eks_viewer" {
  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
    ]
    resources = [
      "arn:aws:eks:${var.aws_region}:${var.aws_account_id}:cluster/${var.eks_cluster_name}",
    ]
  }
}

resource "aws_iam_group" "rbac_group_viewer" {
  path = var.aws_iam_path_k8s_rbac
  name = var.aws_iam_role_k8s_rbac_group_viewer
}

resource "aws_iam_policy" "rbac_policy_viewer" {
  path   = var.aws_iam_path_k8s_rbac
  name   = "${var.aws_iam_role_k8s_rbac_group_viewer}Policy"
  policy = data.aws_iam_policy_document.rbac_eks_viewer.json
}

resource "aws_iam_group_policy_attachment" "rbac_group_policy_viewer" {
  group      = aws_iam_group.rbac_group_viewer.name
  policy_arn = aws_iam_policy.rbac_policy_viewer.arn
}

# ---------------------------------------------------------------------------- #
# IAM User
# ---------------------------------------------------------------------------- #

resource "aws_iam_user" "rbac_user_viewer" {
  path = var.aws_iam_path_k8s_rbac
  name = var.aws_iam_role_k8s_rbac_group_viewer
}

resource "aws_iam_access_key" "rbac_user_viewer" {
  user = aws_iam_user.rbac_user_viewer.name
}

resource "aws_iam_group_membership" "rbac_user_group_membership_viewer" {
  name  = "${aws_iam_group.rbac_group_viewer.name}GroupMembership"
  group = aws_iam_group.rbac_group_viewer.name
  users = [aws_iam_user.rbac_user_viewer.name]
}

# ---------------------------------------------------------------------------- #
# Kubernetes
# ---------------------------------------------------------------------------- #

resource "aws_eks_access_entry" "rbac_user_group_membership_viewer" {
  cluster_name      = var.eks_cluster_name
  principal_arn     = aws_iam_user.rbac_user_viewer.arn
  kubernetes_groups = [var.rbac_group_viewer]
}

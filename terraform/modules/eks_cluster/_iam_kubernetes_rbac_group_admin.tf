# ---------------------------------------------------------------------------- #
# IAM Group
# ---------------------------------------------------------------------------- #

data "aws_iam_policy_document" "rbac_eks_admin" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_group" "rbac_group_admin" {
  path = var.aws_iam_path_k8s_rbac
  name = var.aws_iam_role_k8s_rbac_group_admin
}

resource "aws_iam_policy" "rbac_policy_admin" {
  path   = var.aws_iam_path_k8s_rbac
  name   = "${var.aws_iam_role_k8s_rbac_group_admin}Policy"
  policy = data.aws_iam_policy_document.rbac_eks_admin.json
}

resource "aws_iam_group_policy_attachment" "rbac_group_policy_admin" {
  group      = aws_iam_group.rbac_group_admin.name
  policy_arn = aws_iam_policy.rbac_policy_admin.arn
}

# ---------------------------------------------------------------------------- #
# IAM User
# ---------------------------------------------------------------------------- #

resource "aws_iam_user" "rbac_user_admin" {
  path = var.aws_iam_path_k8s_rbac
  name = var.aws_iam_role_k8s_rbac_group_admin
}

resource "aws_iam_access_key" "rbac_user_admin" {
  user = aws_iam_user.rbac_user_admin.name
}

resource "aws_iam_group_membership" "rbac_user_group_membership_admin" {
  name  = "${aws_iam_group.rbac_group_admin.name}GroupMembership"
  group = aws_iam_group.rbac_group_admin.name
  users = [aws_iam_user.rbac_user_admin.name]
}

# ---------------------------------------------------------------------------- #
# Kubernetes
# ---------------------------------------------------------------------------- #

resource "aws_eks_access_entry" "rbac_user_group_membership_admin" {
  cluster_name      = var.eks_cluster_name
  principal_arn     = aws_iam_user.rbac_user_admin.arn
  kubernetes_groups = [var.rbac_group_admin]
}

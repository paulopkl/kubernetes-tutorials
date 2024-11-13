resource "aws_eks_addon" "csi_driver" {
  depends_on = [
    aws_eks_cluster.demo,
    aws_iam_role.eks_ebs_csi_driver
  ]

  for_each = {
    for addon in var.eks_addons : addon.name => addon
  }

  cluster_name  = aws_eks_cluster.demo.name
  addon_name    = each.value.name // "aws-ebs-csi-driver"
  addon_version = each.value.version //"v1.29.1-eksbuild.1"

  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

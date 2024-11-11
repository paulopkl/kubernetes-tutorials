resource "helm_release" "appmesh_controller" {
  depends_on = [
    aws_eks_node_group.general,
    aws_iam_role_policy_attachment.aws_cloud_map_full_access_controller,
    aws_iam_role_policy_attachment.aws_appmesh_full_access_controller
  ]

  name = "appmesh-controller"

  repository       = "https://aws.github.io/eks-charts"
  chart            = "appmesh-controller"
  namespace        = "appmesh-system"
  create_namespace = true
  version          = "1.12.3"

  set {
    name  = "serviceAccount.name"
    value = "appmesh-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.appmesh_controller.arn
  }

  lifecycle {
    ignore_changes = all
  }
}

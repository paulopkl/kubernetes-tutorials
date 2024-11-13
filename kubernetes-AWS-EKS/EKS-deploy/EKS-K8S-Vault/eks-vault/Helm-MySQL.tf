resource "helm_release" "mysql" {
  depends_on = [
    # aws_eks_node_group.general,
    # aws_iam_role_policy_attachment.aws_cloud_map_full_access_controller,
    # aws_iam_role_policy_attachment.aws_appmesh_full_access_controller
  ]

  name             = "mysql"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "mysql"
  namespace        = var.namespace
  create_namespace = true
  version          = "11.1.2"

  # values = [
  # <<EOF
  #   auth:
  #     rootPassword: "example"
  #     database: "mydatabase"
  #     username: "root"
  #     password: "root_password"
  # EOF
  # ]

  # set {
  #   name  = "serviceAccount.name"
  #   value = "appmesh-controller"
  # }

  # set {
  #   name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  #   value = aws_iam_role.appmesh_controller.arn
  # }

  lifecycle {
    ignore_changes = all
  }
}

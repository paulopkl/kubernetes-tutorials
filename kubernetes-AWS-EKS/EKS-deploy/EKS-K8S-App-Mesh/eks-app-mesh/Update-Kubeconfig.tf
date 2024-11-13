resource "null_resource" "update_kubeconfig" {
  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.general,
    helm_release.appmesh_controller,
    helm_release.appmesh_gateway
  ]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.env}-${var.eks_name} --region ${var.aws_region}"
  }

  # This will trigger the provisioner every time you apply changes to this resource
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [
    aws_eks_cluster.demo,
    aws_eks_node_group.private_nodes,
    helm_release.istio_base,
    helm_release.istiod,
    helm_release.gateway,
  ]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.aws_eks_cluster_name} --region ${var.aws_region}"
  }

  # This will trigger the provisioner every time you apply changes to this resource
  triggers = {
    always_run = "${timestamp()}"
  }
}

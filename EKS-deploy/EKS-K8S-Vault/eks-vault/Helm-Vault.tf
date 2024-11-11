resource "helm_release" "vault" {
  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.general,
    helm_release.mysql
    # aws_iam_role_policy_attachment.aws_cloud_map_full_access_controller,
    # aws_iam_role_policy_attachment.aws_appmesh_full_access_controller
  ]

  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  namespace        = var.namespace
  create_namespace = true
  version          = "1.4.6"

  values = [
    <<EOF
    server:
      affinity: ""
      ha:
          enabled: true
          raft:
            enabled: true
            setNodeId: true
            config: |
                cluster_name = "vault-integrated-storage"
                storage "raft" {
                  path    = "/vault/data/"
                }

                listener "tcp" {
                  address = "[::]:8200"
                  cluster_address = "[::]:8201"
                  tls_disable = "true"
                }
                service_registration "kubernetes" {}
  EOF
  ]

  # set {
  #   name  = "serviceAccount.name"
  #   value = "appmesh-controller"
  # }

  lifecycle {
    ignore_changes = all
  }
}

# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm install my-istio-base-release istio/base -n istio-system --create-namespace  --set global.istioNamespace=istio-system

resource "helm_release" "istio_base" {
  depends_on = [
    aws_eks_cluster.demo,
    aws_eks_node_group.private_nodes
  ]

  name = "my-istio-base-release"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  create_namespace = true
  namespace        = "istio-system"
  version          = "1.17.1"

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }
}

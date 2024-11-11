# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm install gateway istio/gateway -n istio-ingress --create-namespace 

# This is used for the communication for the internet
resource "helm_release" "gateway" {
  depends_on = [
    helm_release.istio_base,
    helm_release.istiod,
  ]

  name = "gateway"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  create_namespace = true
  namespace        = "istio-ingress"
  version          = "1.17.1"
}

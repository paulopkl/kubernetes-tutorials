# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm install my-istiod-release istio/istiod -n istio-system --create-namespace  --set telemetry.enabled=true --set global.istioNamespace=istio-system

resource "helm_release" "istiod" {
  depends_on = [
    helm_release.istio_base
  ]

  name = "my-istiod-release"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  create_namespace = true
  namespace        = "istio-system"
  version          = "1.17.1"

  set {
    name  = "telemetry.enabled"
    value = "true"
  }

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }

  set {
    name  = "meshConfig.ingressService"
    value = "istio-gateway"
  }

  set {
    name  = "meshConfig.ingressSelector"
    value = "gateway"
  }
}

resource "kubectl_manifest" "gateway_ns" {
  depends_on = [kubectl_manifest.mesh]

  yaml_body = file("../k8s/00-gateway-ns.yaml")
}

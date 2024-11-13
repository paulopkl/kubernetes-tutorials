resource "kubectl_manifest" "mesh" {
  depends_on = [helm_release.appmesh_controller]

  yaml_body = file("../k8s/01-mesh.yaml")
}

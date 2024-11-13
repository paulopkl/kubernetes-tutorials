resource "helm_release" "metrics-server" {
  depends_on = [aws_eks_fargate_profile.kube-system]

  name = "metrics-server"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.8.2"

  set {
    name  = "metrics.enabled"
    value = false
  }
}

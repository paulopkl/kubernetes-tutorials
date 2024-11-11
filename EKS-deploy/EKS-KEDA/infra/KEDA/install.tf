resource "helm_release" "keda" {
    depends_on = [
        kubernetes_namespace.keda_namespace,
        local.k8s_service_account_name
    ]

    name       = "keda"
    namespace  = var.kubernetes_keda_namespace
    wait       = true
    timeout    = 6000
    repository = "https://kedacore.github.io/charts"
    chart      = "keda"
    version    = "2.11.2"

    set {
        name = "serviceAccount.create"
        value = false
    }

    set {
        name = "serviceAccount.name"
        value = local.k8s_service_account_name
    }
}

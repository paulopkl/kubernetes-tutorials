resource "null_resource" "vault_generate_keys" {
  depends_on = [helm_release.vault]

  provisioner "local-exec" {
    command = <<EOT
        kubectl exec vault-0 -n ${var.namespace} -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json
    EOT
  }
}

resource "null_resource" "vault_unseal_pod_0" {
  depends_on = [null_resource.vault_generate_keys]

  provisioner "local-exec" {
    command = <<EOT
        $VAULT_UNSEAL_KEY=$(cat ./cluster-keys.json | jq -r ".unseal_keys_b64[]")

        kubectl exec vault-0 -n ${var.namespace} -- vault operator unseal $VAULT_UNSEAL_KEY
    EOT
  }
}

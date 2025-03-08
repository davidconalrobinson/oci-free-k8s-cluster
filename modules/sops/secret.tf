resource "kubernetes_secret" "age_private_key" {
  metadata {
    name      = "age-private-key-secret"
    namespace = "sops-secrets-operator"
  }
  data = {
      "age-private-key": var.age_private_key
  }
  depends_on = [
    kubernetes_namespace.sops
  ]
}

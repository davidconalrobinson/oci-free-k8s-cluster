resource "kubernetes_secret" "age_private_key" {
    metadata {
      name      = "age-private-key-secret"
      namespace = "sops"
    }
    data = {
        "age-private-key": var.age_private_key
    }
}

resource "kubernetes_secret" "secret" {
  for_each = { for index, secret in var.secrets : "${secret.namespace}-${secret.name}" => secret }
  metadata {
    name      = each.value.name
    namespace = each.value.namespace
  }
  data = each.value.data
  depends_on = [
    kubernetes_namespace.namespace
  ]
}

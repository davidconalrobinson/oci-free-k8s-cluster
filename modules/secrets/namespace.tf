resource "kubernetes_namespace" "namespace" {
  for_each = { for index, secret in var.secrets: "${secret.namespace}-${secret.name}" => secret }
  metadata {
    name = each.value.namespace
  }
}

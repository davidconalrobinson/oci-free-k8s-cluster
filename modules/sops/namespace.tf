resource "kubernetes_namespace" "sops" {
  metadata {
    name = "sops"
  }
}

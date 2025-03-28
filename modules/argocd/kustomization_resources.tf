resource "kustomization_resource" "argocd" {
  for_each = data.kustomization_overlay.argocd_manifest.manifests
  manifest = each.value
  depends_on = [
    kubernetes_namespace.argocd
  ]
}

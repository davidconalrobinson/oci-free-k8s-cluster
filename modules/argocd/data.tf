data "kustomization_overlay" "argocd_manifest" {
  namespace = "argocd"
  resources = [
    "https://raw.githubusercontent.com/argoproj/argo-cd/${var.argocd_chart_version}/manifests/install.yaml",
  ]
}

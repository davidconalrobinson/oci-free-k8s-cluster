data "kustomization_overlay" "argocd_manifest" {
  namespace = "argocd"
  resources = [
    "https://raw.githubusercontent.com/argoproj/argo-cd/${var.argocd_chart_version}/manifests/install.yaml",
  ]
  patches {
    target {
      kind = "ConfigMap"
      name = "argocd-cm"
    }
    patch = <<-EOF
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: argocd-cm
        namespace: argocd
      data:
        kustomize.buildOptions: "--enable-helm"
    EOF
  }
}

data "kubernetes_secret_v1" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}

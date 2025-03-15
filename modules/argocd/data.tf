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
        admin.enabled: "true"
        kustomize.buildOptions: "--enable-helm"
        users.anonymous.enabled: "true"
    EOF
  }
  patches {
    target {
      kind = "ConfigMap"
      name = "argocd-rbac-cm"
    }
    patch = <<-EOF
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: argocd-rbac-cm
        namespace: argocd
      data:
        policy.default: "role:readonly"
    EOF
  }
}

data "kubernetes_secret_v1" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}

resource "argocd_application" "application" {
  for_each = toset([
    "argocd-ingress",
    "cert-manager",
    "external-dns",
    "ingress-nginx",
    "oauth2-proxy",
    "sops-secrets-operator",
  ])
  metadata {
    name      = each.value
    namespace = "argocd"
  }
  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = each.value
    }
    source {
      repo_url        = "https://github.com/davidconalrobinson/oci-free-k8s-cluster-apps.git"
      path            = each.value
      target_revision = "master"
    }
    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      sync_options = ["CreateNamespace=true", "Upsert=true"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}

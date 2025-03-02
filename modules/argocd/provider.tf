terraform {
  required_providers {
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.0"
    }
  }
}

provider "kustomization" {
  kubeconfig_raw = var.kube_config
}

provider "kubernetes" {
  host                   = yamldecode(var.kube_config)["clusters"][0]["cluster"]["server"]
  cluster_ca_certificate = base64decode(yamldecode(var.kube_config)["clusters"][0]["cluster"]["certificate-authority-data"])
  exec {
    api_version = yamldecode(var.kube_config)["users"][0]["user"]["exec"]["apiVersion"]
    args        = yamldecode(var.kube_config)["users"][0]["user"]["exec"]["args"]
    command     = yamldecode(var.kube_config)["users"][0]["user"]["exec"]["command"]
  }
}

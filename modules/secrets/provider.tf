provider "kubernetes" {
  host                   = yamldecode(var.kube_config)["clusters"][0]["cluster"]["server"]
  cluster_ca_certificate = base64decode(yamldecode(var.kube_config)["clusters"][0]["cluster"]["certificate-authority-data"])
  exec {
    api_version = yamldecode(var.kube_config)["users"][0]["user"]["exec"]["apiVersion"]
    args        = yamldecode(var.kube_config)["users"][0]["user"]["exec"]["args"]
    command     = yamldecode(var.kube_config)["users"][0]["user"]["exec"]["command"]
  }
}

module "oci" {
  source = "./modules/oci"

  tenancy_ocid        = var.tenancy_ocid
  fingerprint         = var.fingerprint
  user_ocid           = var.user_ocid
  private_key_path    = var.private_key_path
  compartment_name    = var.compartment_name
  region              = var.region
  dns_name            = var.dns_name
  availability_domain = var.availability_domain
  node_image_id       = var.node_image_id
  kubernetes_version  = var.kubernetes_version
}

resource "local_file" "kube_config" {
  content  = module.oci.kube_config
  filename = var.kube_config_path
}

module "secrets" {
  source = "./modules/secrets"

  kube_config = module.oci.kube_config
  secrets     = var.secrets
}

module "argocd" {
  source = "./modules/argocd"

  kube_config      = module.oci.kube_config
  tenancy_ocid     = var.tenancy_ocid
  fingerprint      = var.fingerprint
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  region           = var.region
  compartment_ocid = module.oci.compartment_ocid
}

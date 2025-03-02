variable "tenancy_ocid" {
  description = "The OCID of the Oracle Cloud Infrastructure (OCI) tenancy. See more: [OCI Tenancy OCID](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingtenancy.htm)"
}

variable "region" {
  description = "The OCI region where the resources will be provisioned. See more: [OCI Regions](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm)"
}

variable "user_ocid" {
  description = "The OCID of the user who is creating the resources in OCI. See more: [OCI User OCID](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingusers.htm)"
}

variable "fingerprint" {
  description = "The fingerprint of the public key associated with the user in OCI. See more: [OCI API Keys](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingapikeys.htm)"
}

variable "private_key_path" {
  description = "The file path to the private key used for authentication with OCI. See more: [OCI API Keys](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingapikeys.htm)"
}

variable "dns_name" {
  description = "The DNS name to be used for ingress to the Kubernetes cluster. See more: [OCI DNS](https://docs.oracle.com/en-us/iaas/Content/DNS/Concepts/dnsoverview.htm)"
}

variable "availability_domain" {
  description = "The OCI availability domain where the resources will be provisioned. See more: [OCI Availability Domains](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm#availability-domains)"
}

variable "node_image_id" {
  description = "The OCID of the image used for the compute instances in the Kubernetes cluster. See more: [OCI Compute Images](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingimages.htm)"
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to be used for the cluster. Default is 'v1.31.1'. See more: [Kubernetes Versions](https://kubernetes.io/docs/setup/release/version-skew-policy/)"
  default = "v1.31.1"
}

variable "compartment_name" {
  description = "The name of the OCI compartment where the Kubernetes cluster will be created. Default is 'oci-free-k8s-cluster'. See more: [OCI Compartments](https://docs.oracle.com/en-us/iaas/Content/Identity/Concepts/compartments.htm)"
  default = "oci-free-k8s-cluster"
}

variable "kube_config_path" {
  description = "The file path where the Kubernetes configuration file will be stored. Default is '.kube_config'. See more: [Kubeconfig File](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)"
  default = ".kube_config"
}


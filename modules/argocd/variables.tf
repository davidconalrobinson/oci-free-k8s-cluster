variable "kube_config" {
  description = "The kubeconfig content for accessing the Kubernetes cluster. This can be used to configure `kubectl` to interact with the cluster."
}

variable "tenancy_ocid" {
  description = "The OCID of the Oracle Cloud Infrastructure (OCI) tenancy. See more: [OCI Tenancy OCID](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingtenancy.htm)"
}

variable "compartment_ocid" {
  description = "The OCID (Oracle Cloud Identifier) of the compartment where the resources are deployed. This uniquely identifies the compartment in Oracle Cloud."
}

variable "fingerprint" {
  description = "The fingerprint of the public key associated with the user in OCI. See more: [OCI API Keys](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingapikeys.htm)"
}

variable "user_ocid" {
  description = "The OCID of the user who is creating the resources in OCI. See more: [OCI User OCID](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingusers.htm)"
}

variable "private_key_path" {
  description = "The file path to the private key used for authentication with OCI. See more: [OCI API Keys](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingapikeys.htm)"
}

variable "region" {
  description = "The OCI region where the resources will be provisioned. See more: [OCI Regions](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm)"
}

variable "argocd_chart_version" {
    default = "v2.13.4"
}

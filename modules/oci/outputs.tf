output "kube_config" {
  value       = data.oci_containerengine_cluster_kube_config.kube_config.content
  description = "The kubeconfig content for accessing the Kubernetes cluster. This can be used to configure `kubectl` to interact with the cluster."
}

output "compartment_ocid" {
  value       = oci_identity_compartment.compartment.id
  description = "The OCID (Oracle Cloud Identifier) of the compartment where the resources are deployed. This uniquely identifies the compartment in Oracle Cloud."
}

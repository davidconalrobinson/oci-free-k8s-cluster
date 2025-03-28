output "kube_config" {
  value       = var.kube_config
  description = "The kubeconfig content for accessing the Kubernetes cluster. This can be used to configure `kubectl` to interact with the cluster."
}

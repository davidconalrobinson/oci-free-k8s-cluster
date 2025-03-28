variable "kube_config" {
  description = "The kubeconfig content for accessing the Kubernetes cluster. This can be used to configure `kubectl` to interact with the cluster."
}

variable "secrets" {
  description = "Kubernetes secrets to deploy to cluster."
  default     = []
  type = list(object({
    namespace = string
    name      = string
    data      = map(any)
  }))
}

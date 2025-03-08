variable "kube_config" {
  description = "The kubeconfig content for accessing the Kubernetes cluster. This can be used to configure `kubectl` to interact with the cluster."
}

variable "age_private_key" {
  description = "The private key used for age encryption. This key is kept secret and should never be exposed in public repositories or logs."
}

variable "age_public_key" {
  description = "The public key used for age encryption. This key can be shared with others to allow them to encrypt data that only the corresponding private key can decrypt."
}

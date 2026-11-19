variable "kubeconfig_path" {
  description = "Path to the kubeconfig file used by the example."
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Optional kubeconfig context name. Null uses the current context."
  type        = string
  default     = null
}

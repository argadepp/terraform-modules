variable "release_name" {
  description = "Helm release name."
  type        = string
  validation {
    condition     = length(var.release_name) > 0 && length(var.release_name) <= 53
    error_message = "release_name must contain between 1 and 53 characters."
  }
}

variable "repository" {
  description = "Helm chart repository URL."
  type        = string
  default     = ""
}

variable "chart" {
  description = "Chart name or chart reference."
  type        = string
}

variable "chart_version" {
  description = "Exact or constrained chart version. Prefer pinning an exact version."
  type        = string
}

variable "namespace" {
  description = "Existing Kubernetes namespace in which to install the release."
  type        = string
}

variable "create_namespace" {
  description = "Whether Helm should create the namespace. Keep false when namespace lifecycle is managed separately."
  type        = bool
  default     = false
}

variable "values" {
  description = "List of rendered Helm values YAML documents."
  type        = list(string)
  default     = []
}

variable "set" {
  description = "Additional Helm set values."
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "auto")
  }))
  default = []
}

variable "atomic" {
  description = "Roll back changes on failure."
  type        = bool
  default     = true
}

variable "cleanup_on_fail" {
  description = "Delete a failed installation."
  type        = bool
  default     = true
}

variable "wait" {
  description = "Wait for Kubernetes resources to become ready."
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Timeout in seconds for Helm operations."
  type        = number
  default     = 600
}

variable "max_history" {
  description = "Maximum number of revisions to retain."
  type        = number
  default     = 10
}

variable "lint" {
  description = "Run Helm lint during installation."
  type        = bool
  default     = true
}

variable "namespace_name" {
  description = "Name of the Kubernetes namespace."
  type        = string

  validation {
    condition = (
      length(var.namespace_name) <= 63 &&
      can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.namespace_name))
    )
    error_message = "namespace_name must be a valid DNS label: lowercase letters, numbers, and hyphens, with a maximum length of 63 characters."
  }
}

variable "labels" {
  description = "Labels applied to the namespace and its managed quota and limit-range resources."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations applied to the namespace."
  type        = map(string)
  default     = {}
}

variable "resource_quota" {
  description = "Optional ResourceQuota configuration. Set to null to disable quota management."

  type = object({
    name   = optional(string, "resource-quota")
    hard   = map(string)
    scopes = optional(list(string), [])
  })

  default = null

  validation {
    condition = (
      var.resource_quota == null ||
      (
        length(trimspace(var.resource_quota.name)) > 0 &&
        length(var.resource_quota.hard) > 0
      )
    )
    error_message = "When resource_quota is configured, name must not be empty and hard must contain at least one quota."
  }
}

variable "limit_ranges" {
  description = "Optional map of LimitRange configurations, keyed by Kubernetes LimitRange name."

  type = map(object({
    limits = list(object({
      type                    = string
      max                     = optional(map(string))
      min                     = optional(map(string))
      default                 = optional(map(string))
      default_request         = optional(map(string))
      max_limit_request_ratio = optional(map(string))
    }))
  }))

  default = {}

  validation {
    condition = alltrue([
      for name, config in var.limit_ranges :
      length(trimspace(name)) > 0 && length(config.limits) > 0
    ])
    error_message = "Each limit_ranges entry must have a non-empty name and at least one limit definition."
  }
}

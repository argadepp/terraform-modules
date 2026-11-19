output "namespace_name" {
  description = "Name of the created Kubernetes namespace."
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "namespace_id" {
  description = "Terraform ID of the Kubernetes namespace."
  value       = kubernetes_namespace_v1.this.id
}

output "namespace_uid" {
  description = "UID assigned to the Kubernetes namespace."
  value       = kubernetes_namespace_v1.this.metadata[0].uid
}

output "resource_quota_name" {
  description = "Name of the managed ResourceQuota, or null when quota management is disabled."
  value       = try(kubernetes_resource_quota_v1.this["this"].metadata[0].name, null)
}

output "limit_range_names" {
  description = "Names of the managed LimitRange resources."
  value       = sort(keys(kubernetes_limit_range_v1.this))
}

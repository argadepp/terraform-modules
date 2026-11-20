output "release_name" {
  description = "Name of the Helm release."
  value       = helm_release.this.name
}

output "namespace" {
  description = "Namespace where the release is installed."
  value       = helm_release.this.namespace
}

output "chart" {
  description = "Chart name and deployed chart version."
  value       = helm_release.this.chart
}

output "version" {
  description = "Deployed chart version."
  value       = helm_release.this.version
}

output "status" {
  description = "Current Helm release status."
  value       = helm_release.this.status
}

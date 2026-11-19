terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}

provider "kubernetes" {
  config_path    = pathexpand(var.kubeconfig_path)
  config_context = var.kube_context
}

module "namespace" {
  source = "../../"

  namespace_name = "demo-app"

  labels = {
    environment = "development"
    managed-by  = "terraform"
    team        = "platform"
  }

  annotations = {
    description = "Demo application namespace"
  }

  resource_quota = {
    name = "demo-quota"

    hard = {
      pods            = "10"
      requests.cpu    = "4"
      requests.memory = "8Gi"
      limits.cpu      = "8"
      limits.memory   = "16Gi"
    }
  }

  limit_ranges = {
    container-defaults = {
      limits = [
        {
          type = "Container"

          default = {
            cpu    = "500m"
            memory = "512Mi"
          }

          default_request = {
            cpu    = "100m"
            memory = "128Mi"
          }

          max = {
            cpu    = "2"
            memory = "2Gi"
          }
        }
      ]
    }
  }
}

output "namespace_name" {
  value = module.namespace.namespace_name
}

output "resource_quota_name" {
  value = module.namespace.resource_quota_name
}

output "limit_range_names" {
  value = module.namespace.limit_range_names
}

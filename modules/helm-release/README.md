# Helm Release Terraform Module

Installs or upgrades one Helm chart release. The calling root module owns provider configuration, namespace lifecycle, and environment-specific values.

## Features

- Installs or upgrades a chart from a Helm repository
- Supports environment-specific values documents and additional set values
- Supports atomic rollback, failure cleanup, readiness waiting, timeout, history, and lint options
- Exposes release name, namespace, chart, version, and status
- Does not create namespaces by default; pair it with the Kubernetes namespace module

## Requirements

- Terraform >= 1.3.0
- HashiCorp Helm provider >= 2.12.0, < 3.0.0
- Helm repository reachable from the Terraform runner
- Kubernetes provider configuration supplied by the calling root module

## Usage

```hcl
module "nginx" {
  source = "git::https://github.com/argadepp/terraform-modules.git//modules/helm-release?ref=<PINNED_COMMIT_SHA>"
  release_name  = "nginx"
  repository    = "https://charts.bitnami.com/bitnami"
  chart         = "nginx"
  chart_version = "18.2.4"
  namespace     = "dev-demo-app"
  values        = [file("${path.root}/../environments/dev/applications/nginx/values.yaml")]
  depends_on    = [module.namespace]
}
```

Pin the module source to a reviewed commit SHA. Verify the example chart version is available before deploying.

## Safety

- Keep `create_namespace = false` when Terraform separately manages namespaces.
- Pin chart versions and module source revisions for repeatability.
- Do not commit plaintext credentials or secret values in values files. Use a secret manager or protected CI variables.
- Review plans carefully: chart/value changes can roll workloads; removing a release destroys the Helm release.

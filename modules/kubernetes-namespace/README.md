# Kubernetes Namespace Terraform Module

Creates and manages a Kubernetes namespace, with optional ResourceQuota and LimitRange resources, using the HashiCorp Kubernetes provider.

## Features

- Namespace creation
- Configurable namespace labels and annotations
- Optional ResourceQuota
- Zero or more configurable LimitRange resources
- Outputs for namespace metadata and managed policy resources
- Provider configuration supplied by the calling root module

## Requirements

- Terraform >= 1.3.0
- HashiCorp Kubernetes provider >= 3.0.0, < 4.0.0
- Access to the target Kubernetes cluster
- Kubernetes provider authentication configured by the root module

## Resources

- `kubernetes_namespace_v1`
- `kubernetes_resource_quota_v1`
- `kubernetes_limit_range_v1`

## Usage

See [examples/basic](examples/basic) for a complete example including a ResourceQuota and LimitRange.

The calling root module is responsible for configuring the Kubernetes provider and selecting the intended cluster/context. This module does not configure credentials or select a kubeconfig context.

## Inputs

| Name | Description | Required |
|---|---|---|
| `namespace_name` | Kubernetes namespace name | Yes |
| `labels` | Labels applied to the namespace and managed policy resources | No |
| `annotations` | Namespace annotations | No |
| `resource_quota` | Optional ResourceQuota configuration; null disables it | No |
| `limit_ranges` | Map of LimitRange configurations; empty map disables them | No |

## Outputs

| Name | Description |
|---|---|
| `namespace_name` | Namespace name |
| `namespace_id` | Terraform resource ID |
| `namespace_uid` | Kubernetes namespace UID |
| `resource_quota_name` | ResourceQuota name, or null |
| `limit_range_names` | Names of managed LimitRange resources |

## Operational and security considerations

- Configure the Kubernetes provider in the root module. Do not commit kubeconfig files, client certificates, or credentials.
- ResourceQuota and LimitRange policies are enforced by Kubernetes; ensure their values are appropriate for the workloads and cluster.
- Resource quota values use Kubernetes quantity strings such as `"4"`, `"500m"`, and `"8Gi"`.
- Changing a namespace name can replace the namespace.
- Deleting a namespace can delete workloads and other namespaced resources inside it. Review plans carefully before any apply or destroy operation.
- Terraform state may contain cluster metadata and other sensitive infrastructure details; protect the state backend.

## Validation

Run formatting and validation from the module directory. Initialization with `-backend=false` avoids configuring a backend, but provider schema downloads may still require network access.

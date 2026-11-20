resource "kubernetes_namespace_v1" "this" {
  metadata {
    name        = var.namespace_name
    labels      = var.labels
    annotations = var.annotations
  }
}

resource "kubernetes_resource_quota_v1" "this" {
  for_each = var.resource_quota == null ? {} : {
    this = var.resource_quota
  }

  metadata {
    name      = each.value.name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = var.labels
  }

  spec {
    hard   = each.value.hard
    scopes = length(each.value.scopes) > 0 ? each.value.scopes : null
  }
}

resource "kubernetes_limit_range_v1" "this" {
  for_each = var.limit_ranges

  metadata {
    name      = each.key
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = var.labels
  }

  spec {
    dynamic "limit" {
      for_each = each.value.limits

      content {
        type                    = limit.value.type
        max                     = limit.value.max
        min                     = limit.value.min
        default                 = limit.value.default
        default_request         = limit.value.default_request
        max_limit_request_ratio = limit.value.max_limit_request_ratio
      }
    }
  }
}

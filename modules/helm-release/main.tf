resource "helm_release" "this" {
  name             = var.release_name
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = var.create_namespace
  values           = var.values
  set              = var.set

  atomic          = var.atomic
  cleanup_on_fail = var.cleanup_on_fail
  wait            = var.wait
  timeout         = var.timeout
  max_history     = var.max_history
  lint            = var.lint
}

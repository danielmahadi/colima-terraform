resource "helm_release" "kube-prometheus-stack" {
  chart       = "kube-prometheus-stack"
  name        = "kube-prometheus-stack"
  namespace   = kubernetes_namespace_v1.monitoring.metadata[0].name
  repository  = var.kube_prometheus_stack_chart_url
  version     = var.kube_prometheus_stack_version
}

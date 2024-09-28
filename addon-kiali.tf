resource "helm_release" "kiali" {
  chart       = "kiali-server"
  name        = "kiali"
  namespace   = kubernetes_namespace_v1.istio_system.metadata[0].name
  repository  = var.kiali_chart_url
  version     = var.kiali_version

  set {
    name  = "auth.strategy"
    value = "anonymous"
  }

  set {
    name  = "external_services.prometheus.url"
    value = "http://kube-prometheus-stack-prometheus.monitoring.svc:9090"
  }
}

resource "helm_release" "argo_cd" {
  chart       = "argo-cd"
  name        = "argo-cd"
  namespace   = kubernetes_namespace_v1.argo_cd.metadata[0].name
  repository  = var.argo_cd_chart_url
  version     = var.argo_cd_chart_version

  values = [
    yamlencode(yamldecode(file("${path.module}/helm-values/argo-cd.yaml"))),
  ]
}

resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = "istio-system"

    labels = {
      "istio-injection"                     = "disabled"
      "pod-security.kubernetes.io/enforce"  = "privileged"
    }
  }
}

resource "helm_release" "istio_base" {
  chart       = "base"
  name        = "istio-base"
  namespace   = kubernetes_namespace_v1.istio_system.metadata[0].name
  repository  = var.istio_chart_url
  version     = var.istio_chart_version
}

resource "helm_release" "istio_cni" {
  chart       = "cni"
  name        = "istio-cni"
  namespace   = kubernetes_namespace_v1.istio_system.metadata[0].name
  repository  = var.istio_chart_url
  version     = var.istio_chart_version

  set {
    name  = "profile"
    value = "ambient"
  }

  depends_on = [
    helm_release.istio_base,
  ]
}

resource "helm_release" "istiod" {
  chart       = "istiod"
  name        = "istiod"
  namespace   = kubernetes_namespace_v1.istio_system.metadata[0].name
  repository  = var.istio_chart_url
  version     = var.istio_chart_version
  wait        = true

  values = [
    yamlencode(yamldecode(file("${path.module}/helm-values/istiod.yaml"))),
  ]

  set {
    name  = "profile"
    value = "ambient"
  }

  depends_on = [
    helm_release.istio_base,
  ]
}

resource "helm_release" "ztunnel" {
  chart       = "ztunnel"
  name        = "ztunnel"
  namespace   = kubernetes_namespace_v1.istio_system.metadata[0].name
  repository  = var.istio_chart_url
  version     = var.istio_chart_version

  set {
    name  = "profile"
    value = "ambient"
  }

  depends_on = [
    helm_release.istio_base,
  ]
}

resource "kubernetes_namespace_v1" "istio_ingress" {
  metadata {
    name = "istio-ingress"

    labels = {
      "istio-injection"                     = "enabled"
      "pod-security.kubernetes.io/enforce"  = "privileged"
    }
  }
}

resource "helm_release" "istio_ingress" {
  chart       = "gateway"
  name        = "istio-ingress"
  namespace   = kubernetes_namespace_v1.istio_ingress.metadata[0].name
  repository  = var.istio_chart_url
  version     = var.istio_chart_version

  values = [
    yamlencode(yamldecode(file("${path.module}/helm-values/istio-ingress.yaml"))),
  ]

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod,
  ]
}

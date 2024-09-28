resource "kubernetes_namespace_v1" "istio_ingress" {
  metadata {
    name = "istio-ingress"

    labels = {
      "istio-injection"                     = "enabled"
      "pod-security.kubernetes.io/enforce"  = "privileged" # because Gateway
    }
  }
}

resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = "istio-system"

    labels = {
      "istio-injection"                     = "disabled"
      "pod-security.kubernetes.io/enforce"  = "privileged" # because CNI
    }
  }
}

resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"

    labels = {
      "istio.io/dataplane-mode"             = "ambient"
      "pod-security.kubernetes.io/enforce"  = "privileged" # because prometheus-node-exporter
    }
  }
}

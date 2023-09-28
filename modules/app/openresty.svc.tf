
resource "kubernetes_service" "openresty_server" {
  count = var.has_openresty ? 1 : 0

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      spec[0].port[0],
      spec[0].port[1]
    ]
  }

  metadata {
    name      = "openresty-server"
    namespace = var.namespace

    labels = {
      #   "service.beta.kubernetes.io/hash" = "d233bf00296726abd8c8fd741e86521efe44c7278d05368fdb56acb6"
    }

    annotations = var.openresty_annotations

    # finalizers = ["service.k8s.alibaba/resources"]
  }

  spec {
    port {
      name        = "http-80"
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }

    port {
      name        = "http-443"
      protocol    = "TCP"
      port        = 443
      target_port = "443"
    }

    selector = {
      app = "openresty"
    }

    type                    = var.has_load_balancer ? "LoadBalancer" : "NodePort"
    session_affinity        = "None"
    ip_families             = ["IPv4"]
    external_traffic_policy = var.has_load_balancer ? "Local" : null
  }
}

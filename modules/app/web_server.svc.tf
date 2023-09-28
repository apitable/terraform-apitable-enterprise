
resource "kubernetes_service" "web_server" {
  count = var.has_web_server ? 1 : 0
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "web-server"
    namespace = var.namespace
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      app = "web-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}
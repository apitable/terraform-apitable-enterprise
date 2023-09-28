
resource "kubernetes_service" "scheduler_server" {
  count = var.has_scheduler_server ? 1 : 0

  depends_on = [
    kubernetes_namespace.this
  ]

  metadata {
    name      = "scheduler-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "scheduler-server-3333-3333"
      protocol    = "TCP"
      port        = 3333
      target_port = "3333"
    }

    selector = {
      app = "scheduler-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}

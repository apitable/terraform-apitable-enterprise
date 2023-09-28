
# server
resource "kubernetes_service" "job_admin_server" {
  count = var.has_job_admin_server ? 1 : 0
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "job-admin-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "job-admin-server-8080-8080"
      protocol    = "TCP"
      port        = 8080
      target_port = "8080"
    }

    selector = {
      app = "job-admin-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}


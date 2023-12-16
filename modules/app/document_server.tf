locals {
  default_document_server_resources = {
    replicas                       = "1"
    max_replicas                   = "50"
    requests_cpu                   = "100m"
    requests_memory                = "512Mi"
    limits_cpu                     = "1500m"
    limits_memory                  = "8192Mi"
    rolling_update_max_unavailable = "25%"
    rolling_update_max_surge       = "25%"
    cpu_utilization_percentage     = "500"
  }
}

locals {
  document_server_resources = merge(local.default_document_server_resources, lookup(var.resources, "document_server", {}))
}

resource "kubernetes_deployment" "document_server" {
  wait_for_rollout = var.is_wait
  count            = var.has_document_server ? 1 : 0

  depends_on = [
    kubernetes_deployment.backend_server,
    kubernetes_namespace.this
  ]

  metadata {
    name      = "document-server"
    namespace = var.namespace

    labels = {
      app = "document-server"
    }
  }

  spec {
    replicas = local.document_server_resources["replicas"]

    selector {
      match_labels = {
        app = "document-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "document-server"
        }
      }

      spec {

        node_selector = var.node_selector

        container {
          name  = "document-server"
          image = "${var.registry}/${lookup(local.image_namespaces, "room_server")}/room-server:${lookup(local.image_tags, "room_server")}"

          env_from {
            config_map_ref {
              name = "document-server-env"
            }
          }

          resources {
            requests = {
              cpu = local.document_server_resources["requests_cpu"]
            }

            limits = {
            }
          }

          volume_mount {
            name       = "document-server-1658224800000"
            mount_path = "/home/vikadata/packages/room-server/logs"
          }

          volume_mount {
            name       = "document-server-1658224800000"
            mount_path = "/app/packages/room-server/logs"
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          image_pull_policy          = var.image_pull_policy
        }

        volume {
          name = "document-server-1658224800000"
          empty_dir {}
        }

        image_pull_secrets {
          name = "regcred"
        }
        restart_policy                   = "Always"
        termination_grace_period_seconds = 30
        dns_policy                       = "ClusterFirst"
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = local.document_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.document_server_resources["rolling_update_max_surge"]
      }
    }

    revision_history_limit    = 10
    progress_deadline_seconds = 600
  }

  //Whether to ignore the change of image tag.
  lifecycle {
    ignore_changes = [
      spec[0].template[0].spec[0].affinity,
    ]
  }
}

resource "kubernetes_service" "document_server" {
  metadata {
    name      = "document-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "document-server-3333-3333"
      protocol    = "TCP"
      port        = 3333
      target_port = "3333"
    }

    port {
      name        = "document-server-3006-3006"
      protocol    = "TCP"
      port        = 3006
      target_port = "3006"
    }

    selector = {
      app = var.has_document_server ? "document-server" : "room-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "document_server_autoscaler" {
  count = var.has_document_server && local.document_server_resources["replicas"] > 0 ? 1 : 0
  metadata {
    name      = "document-server-autoscaler-v2beta2"
    namespace = var.namespace
  }

  spec {
    min_replicas = local.document_server_resources["replicas"]
    max_replicas = local.document_server_resources["max_replicas"]

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "document-server"
    }
    target_cpu_utilization_percentage = local.document_server_resources["cpu_utilization_percentage"]
  }
}

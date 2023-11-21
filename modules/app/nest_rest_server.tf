locals {
  default_nest_rest_server_resources = {
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
  nest_rest_server_resources = merge(local.default_nest_rest_server_resources, lookup(var.resources, "nest_rest_server", {}))
}

resource "kubernetes_deployment" "nest_rest_server" {
  wait_for_rollout = var.is_wait
  count            = var.has_nest_rest_server ? 1 : 0

  depends_on = [
    kubernetes_deployment.backend_server,
    kubernetes_namespace.this
  ]

  metadata {
    name      = "nest-rest-server"
    namespace = var.namespace

    labels = {
      app = "nest-rest-server"
    }

    annotations = {
      # "deployment.kubernetes.io/revision" = "1"
    }
  }

  spec {
    replicas = local.nest_rest_server_resources["replicas"]

    selector {
      match_labels = {
        app = "nest-rest-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "nest-rest-server"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
        }
      }

      spec {

        node_selector = var.node_selector

        container {
          name  = "nest-rest-server"
          image = "${var.registry}/${lookup(local.image_namespaces, "room_server")}/room-server:${lookup(local.image_tags, "room_server")}"

          env_from {
            config_map_ref {
              name = "nest-rest-server-env"
            }
          }

          resources {
            requests = {
              cpu = local.nest_rest_server_resources["requests_cpu"]
               memory = local.nest_rest_server_resources["requests_memory"]     //@add_tf_local
            }

            limits = {
                cpu      = local.fusion_server_resources["limits_cpu"]          //@add_tf_local
                memory   = local.fusion_server_resources["limits_memory"]       //@add_tf_local
            }
          }

          liveness_probe {
            http_get {
              path   = "/actuator/health"
              port   = "3333"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 45
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path   = "/actuator/health"
              port   = "3333"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 15
            success_threshold     = 1
            failure_threshold     = 3
          }

          startup_probe {
            http_get {
              path   = "/actuator/health"
              port   = "3333"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          volume_mount {
            name       = "nest-rest-server-1658224800000"
            mount_path = "/home/vikadata/packages/room-server/logs"
          }

          volume_mount {
            name       = "nest-rest-server-1658224800000"
            mount_path = "/app/packages/room-server/logs"
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          image_pull_policy          = var.image_pull_policy
        }

        volume {
          name = "nest-rest-server-1658224800000"
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
        max_unavailable = local.nest_rest_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.nest_rest_server_resources["rolling_update_max_surge"]
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

resource "kubernetes_service" "nest_rest_server" {
  metadata {
    name      = "nest-rest-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "nest-rest-server-3333-3333"
      protocol    = "TCP"
      port        = 3333
      target_port = "3333"
    }

    selector = {
      app = var.has_nest_rest_server ? "nest-rest-server" : "room-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "nest_rest_server_autoscaler" {
  count = var.has_nest_rest_server ? 1 : 0
  metadata {
    name      = "nest-rest-server-autoscaler-v2beta2"
    namespace = var.namespace
  }

  spec {
    min_replicas = local.nest_rest_server_resources["replicas"]
    max_replicas = local.nest_rest_server_resources["max_replicas"]

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "nest-rest-server"
    }
    target_cpu_utilization_percentage = local.nest_rest_server_resources["cpu_utilization_percentage"]
  }
}

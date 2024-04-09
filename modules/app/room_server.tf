locals {
  default_room_server_resources = {
    replicas                       = "2"
    max_replicas                   = "20"
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
  room_server_resources = merge(local.default_room_server_resources, lookup(var.resources, "room_server", {}))
}

resource "kubernetes_deployment" "room_server" {
  wait_for_rollout = var.is_wait
  count            = var.has_room_server ? 1 : 0

  depends_on = [
    kubernetes_deployment.backend_server,
    kubernetes_namespace.this
  ]

  metadata {
    name      = "room-server"
    namespace = var.namespace

    labels = {
      app = "room-server"
    }

  }

  spec {
    replicas = local.room_server_resources["replicas"]

    selector {
      match_labels = {
        app = "room-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "room-server"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
          "configmap.room-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.room_server_env.data)) : "not_enabled"
        }
      }

      spec {

        node_selector = var.node_selector

        container {
          name  = "room-server"
          image = "${var.registry}/${lookup(local.image_namespaces, "room_server")}/room-server:${lookup(local.image_tags, "room_server")}"

          env_from {
            config_map_ref {
              name = "room-server-env"
            }
          }

          resources {
            requests = {
              cpu = local.room_server_resources["requests_cpu"]
               memory = local.room_server_resources["requests_memory"]          //@add_tf_local
            }
            limits = {
                cpu      = local.room_server_resources["limits_cpu"]          //@add_tf_local
                memory   = local.room_server_resources["limits_memory"]       //@add_tf_local
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
            name       = "room-server-1658224800000"
            mount_path = "/home/vikadata/packages/room-server/logs"
          }

          volume_mount {
            name       = "room-server-1658224800000"
            mount_path = "/app/packages/room-server/logs"
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          image_pull_policy          = var.image_pull_policy
        }

        volume {
          name = "room-server-1658224800000"
          empty_dir {}
        }

        image_pull_secrets {
          name = "regcred"
        }
        restart_policy                   = "Always"
        termination_grace_period_seconds = 30
        dns_policy                       = "ClusterFirst"

        dynamic "affinity" {
          for_each = var.affinity
          content {
            dynamic "node_affinity" {
              for_each = affinity.value["node_affinity"]
              content {
                dynamic "required_during_scheduling_ignored_during_execution" {
                  for_each = node_affinity.value["required_during_scheduling_ignored_during_execution"]
                  content {
                    dynamic "node_selector_term" {
                      for_each = required_during_scheduling_ignored_during_execution.value["node_selector_term"]
                      content {
                        dynamic "match_expressions" {
                          for_each = node_selector_term.value["match_expressions"]
                          content {
                            key      = match_expressions.value.key
                            operator = match_expressions.value.operator
                            values   = match_expressions.value.values
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }

        dynamic "toleration" {
          for_each = var.tolerations
          content {
            effect   = toleration.value["effect"]
            key      = toleration.value["key"]
            operator = toleration.value["operator"]
            value    = toleration.value["value"]
          }
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = local.room_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.room_server_resources["rolling_update_max_surge"]
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

resource "kubernetes_service" "room_server" {
  count = var.has_room_server ? 1 : 0
  metadata {
    name      = "room-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "room-server-3333-3333"
      protocol    = "TCP"
      port        = 3333
      target_port = "3333"
    }

    port {
      name        = "room-server-3334-3334"
      protocol    = "TCP"
      port        = 3334
      target_port = "3334"
    }

    port {
      name        = "room-server-3006-3006"
      protocol    = "TCP"
      port        = 3006
      target_port = "3006"
    }

    selector = {
      app = "room-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "room_server_autoscaler" {
  count = var.has_room_server ? 1 : 0
  metadata {
    name      = "room-server-autoscaler-v2beta2"
    namespace = var.namespace
  }

  spec {
    min_replicas = local.room_server_resources["replicas"]
    max_replicas = local.room_server_resources["max_replicas"]

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "room-server"
    }
    target_cpu_utilization_percentage = local.room_server_resources["cpu_utilization_percentage"]
  }
}

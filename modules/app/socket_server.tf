locals {
  default_socket_server_resources = {
    replicas                       = "1"
    requests_cpu                   = "100m"
    requests_memory                = "512Mi"
    limits_cpu                     = "1000m"
    limits_memory                  = "2048Mi"
    rolling_update_max_unavailable = "25%"
    rolling_update_max_surge       = "25%"
  }
}

locals {
  socket_server_resources = merge(local.default_socket_server_resources, lookup(var.resources, "socket_server", {}))
}

resource "kubernetes_deployment" "socket_server" {
  wait_for_rollout = var.is_wait
  count            = var.has_socket_server ? 1 : 0
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "socket-server"
    namespace = var.namespace

    labels = {
      app = "socket-server"
    }

  }

  spec {
    replicas = local.socket_server_resources["replicas"]

    selector {
      match_labels = {
        app = "socket-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "socket-server"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
          "configmap.socket-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.socket_server_env.data)) : "not_enabled"
        }
      }

      spec {

        node_selector = var.node_selector

        container {
          name              = "socket-server"
          image             = "${var.registry}/${lookup(local.image_namespaces, "room_server")}/room-server:${lookup(local.image_tags, "socket_server")}"
          image_pull_policy = var.image_pull_policy

          env_from {
            config_map_ref {
              name = "socket-server-env"
            }
          }

          resources {
            requests = {
              cpu = local.socket_server_resources["requests_cpu"]
               memory = local.socket_server_resources["requests_memory"]    //@add_tf_local
            }
            limits = {
               cpu      = local.socket_server_resources["limits_cpu"]        //@add_tf_local
               memory   = local.socket_server_resources["limits_memory"]     //@add_tf_local
            }
          }

          liveness_probe {
            http_get {
              path   = "/socket/health"
              port   = "3001"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 30
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path   = "/socket/health"
              port   = "3001"
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
              path   = "/socket/health"
              port   = "3001"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          volume_mount {
            name       = "socket-server-1658224800000"
            mount_path = "/app/packages/socket-server/logs"
          }

          volume_mount {
            name       = "socket-server-1658224800000"
            mount_path = "/app/packages/room-server/logs"
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
        }

        volume {
          name = "socket-server-1658224800000"
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
        max_unavailable = local.socket_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.socket_server_resources["rolling_update_max_surge"]
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

resource "kubernetes_service" "socket_server" {
  count = var.has_socket_server ? 1 : 0
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "socket-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "socket-server-3001-3001"
      protocol    = "TCP"
      port        = 3001
      target_port = "3001"
    }

    port {
      name        = "socket-server-3002-3002"
      protocol    = "TCP"
      port        = 3002
      target_port = "3002"
    }

    port {
      name        = "socket-server-3005-3005"
      protocol    = "TCP"
      port        = 3005
      target_port = "3005"
    }

    port {
      name        = "socket-server-3007-3007"
      protocol    = "TCP"
      port        = 3007
      target_port = "3007"
    }

    selector = {
      app = "socket-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}

locals {
  default_fusion_server_resources = {
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
  fusion_server_resources = merge(local.default_fusion_server_resources, lookup(var.resources, "fusion_server", {}))
}

resource "kubernetes_deployment" "fusion_server" {
  count = var.has_fusion_server ? 1 : 0

  depends_on = [
    kubernetes_deployment.backend_server,
    kubernetes_namespace.this
  ]

  metadata {
    name      = "fusion-server"
    namespace = var.namespace

    labels = {
      app = "fusion-server"
    }

  }

  spec {
    replicas = local.fusion_server_resources["replicas"]

    selector {
      match_labels = {
        app = "fusion-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "fusion-server"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
          "configmap.fusion-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.fusion_server_env.data)) : "not_enabled"
        }
      }

      spec {

        node_selector = var.node_selector

        container {
          name  = "fusion-server"
          image = "${var.registry}/${lookup(local.image_namespaces, "room_server")}/room-server:${lookup(local.image_tags, "room_server")}"

          env_from {
            config_map_ref {
              name = "fusion-server-env"
            }
          }


          resources {
            requests = {
              cpu = local.fusion_server_resources["requests_cpu"]
               memory = local.fusion_server_resources["requests_memory"]     //@add_tf_local
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
            period_seconds        = 30
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
            name       = "fusion-server-1658224800000"
            mount_path = "/home/vikadata/packages/room-server/logs"
          }

          volume_mount {
            name       = "fusion-server-1658224800000"
            mount_path = "/app/packages/room-server/logs"
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          image_pull_policy          = var.image_pull_policy
        }

        volume {
          name = "fusion-server-1658224800000"
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
        max_unavailable = local.fusion_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.fusion_server_resources["rolling_update_max_surge"]
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

resource "kubernetes_service" "fusion_server" {
  count = var.has_fusion_server ? 1 : 0
  metadata {
    name      = "fusion-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "fusion-server-3333-3333"
      protocol    = "TCP"
      port        = 3333
      target_port = "3333"
    }

    selector = {
      app = "fusion-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}


resource "kubernetes_horizontal_pod_autoscaler" "fusion_server_autoscaler" {
  count = var.has_fusion_server ? 1 : 0
  metadata {
    name      = "fusion-server-autoscaler-v2beta2"
    namespace = var.namespace
  }

  spec {
    min_replicas = local.fusion_server_resources["replicas"]
    max_replicas = local.fusion_server_resources["max_replicas"]

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "fusion-server"
    }
    target_cpu_utilization_percentage = local.fusion_server_resources["cpu_utilization_percentage"]

  }
}

locals {
  default_scheduler_server_resources = {
    replicas                       = "1"
    requests_cpu                   = "100m"
    requests_memory                = "1024Mi"
    limits_cpu                     = "1500m"
    limits_memory                  = "4096Mi"
    rolling_update_max_unavailable = "0%"
    rolling_update_max_surge       = "25%"
  }
}

locals {
  scheduler_server_resources = merge(local.default_scheduler_server_resources, lookup(var.resources, "scheduler_server", {}))
}

resource "kubernetes_deployment" "scheduler_server" {
  wait_for_rollout = var.is_wait
  count            = var.has_scheduler_server ? 1 : 0

  depends_on = [
    kubernetes_namespace.this
  ]

  metadata {
    name      = "scheduler-server"
    namespace = var.namespace

    labels = {
      app = "scheduler-server"
    }

  }

  spec {
    replicas = local.scheduler_server_resources["replicas"]

    selector {
      match_labels = {
        app = "scheduler-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "scheduler-server"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
          "configmap.scheduler-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.scheduler_server_env.data)) : "not_enabled"

        }
      }

      spec {

        node_selector = var.node_selector

        container {
          name  = "scheduler-server"
          image = "${var.registry}/${lookup(local.image_namespaces, "room_server")}/room-server:${lookup(local.image_tags, "room_server")}"

          env_from {
            config_map_ref {
              name = "scheduler-server-env"
            }
          }

          resources {
            requests = {
              cpu = local.scheduler_server_resources["requests_cpu"]
               memory = local.scheduler_server_resources["requests_memory"]      //@add_tf_local
            }
            limits = {
               cpu      = local.scheduler_server_resources["limits_cpu"]          //@add_tf_local
               memory   = local.scheduler_server_resources["limits_memory"]       //@add_tf_local
            }
          }

          volume_mount {
            name       = "scheduler-server-1658224800000"
            mount_path = "/home/vikadata/packages/room-server/logs"
          }

          volume_mount {
            name       = "scheduler-server-1658224800000"
            mount_path = "/app/packages/room-server/logs"
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          image_pull_policy          = var.image_pull_policy
        }

        volume {
          name = "scheduler-server-1658224800000"
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
        max_unavailable = local.scheduler_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.scheduler_server_resources["rolling_update_max_surge"]
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

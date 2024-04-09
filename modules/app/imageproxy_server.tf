locals {
  default_imageproxy_server_resources = {
    replicas                       = "1"
    requests_cpu                   = "500m"
    requests_memory                = "1024Mi"
    limits_cpu                     = "1500m"
    limits_memory                  = "8192Mi"
    rolling_update_max_unavailable = "0%"
    rolling_update_max_surge       = "25%"
  }
}

locals {
  imageproxy_server_resources = merge(local.default_imageproxy_server_resources, lookup(var.resources, "imageproxy_server", {}))
}

resource "kubernetes_deployment" "imageproxy_server" {
  wait_for_rollout = var.is_wait
  count            = var.has_imageproxy_server ? 1 : 0
  depends_on = [
    kubernetes_namespace.this
  ]

  metadata {
    name      = "imageproxy-server"
    namespace = var.namespace

    labels = {
      app = "imageproxy-server"
    }

    #    annotations = {
    #      # "deployment.kubernetes.io/revision" = "23"
    #      # "configmap.imageproxy-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.imageproxy_server_env.data)) : "not_enabled"
    #    }
  }

  spec {
    replicas = local.imageproxy_server_resources["replicas"]

    selector {
      match_labels = {
        app = "imageproxy-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "imageproxy-server"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
          "configmap.imageproxy-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.imageproxy_server_env[count.index].data)) : "not_enabled"
        }
      }

      spec {

        node_selector = var.node_selector

        container {
          name  = "imageproxy-server"
          image = "${var.registry}/${lookup(local.image_namespaces, "imageproxy_server")}/imageproxy-server:${lookup(local.image_tags, "imageproxy_server")}"

          env_from {
            config_map_ref {
              name = "imageproxy-server-env"
            }
          }

          resources {
            requests = {
              cpu    = local.imageproxy_server_resources["requests_cpu"]
              memory = local.imageproxy_server_resources["requests_memory"]
            }
            limits = {
              cpu    = local.imageproxy_server_resources["limits_cpu"]
              memory = local.imageproxy_server_resources["limits_memory"]
            }
          }

          liveness_probe {
            http_get {
              path   = "/metrics"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 15
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path   = "/metrics"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 3
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          image_pull_policy          = var.image_pull_policy
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
        max_unavailable = "25%"
        max_surge       = "25%"
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

resource "kubernetes_service" "imageproxy_server" {
  count = var.has_imageproxy_server ? 1 : 0
  metadata {
    name      = "imageproxy-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "imageproxy-server-8080-8080"
      protocol    = "TCP"
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "imageproxy-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}

locals {
  default_databus_server_resources = {
    replicas                       = "1"
    max_replicas                   = "10"
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
  databus_server_resources = merge(local.default_databus_server_resources, lookup(var.resources, "databus_server", {}))
}

resource "kubernetes_deployment" "databus_server" {
  wait_for_rollout = var.is_wait
  count            = var.has_databus_server ? 1 : 0

  depends_on = [
    kubernetes_deployment.backend_server,
    kubernetes_namespace.this
  ]

  metadata {
    name      = "databus-server"
    namespace = var.namespace

    labels = {
      app = "databus-server"
    }

    #    annotations = {
    #      # "deployment.kubernetes.io/revision" = "23"
    #      "configmap.databus-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.databus_server_env.data)) : "not_enabled"
    #    }
  }

  spec {
    replicas = local.databus_server_resources["replicas"]

    selector {
      match_labels = {
        app = "databus-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "databus-server"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
          "configmap.databus-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.databus_server_env.data)) : "not_enabled"
        }
      }

      spec {

        node_selector = var.node_selector

        container {
          name  = "databus-server"
          image = "${var.registry}/${lookup(local.image_namespaces, "databus_server")}/databus-server:${lookup(local.image_tags, "databus_server")}"

          env_from {
            config_map_ref {
              name = "databus-server-env"
            }
          }

          resources {
            requests = {
              cpu = local.databus_server_resources["requests_cpu"]
               memory = local.databus_server_resources["requests_memory"]          //@add_tf_local
            }
            limits = {
                cpu      = local.databus_server_resources["limits_cpu"]          //@add_tf_local
                memory   = local.databus_server_resources["limits_memory"]       //@add_tf_local
            }
          }

          liveness_probe {
            http_get {
              path   = "/databus"
              port   = "8625"
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
              path   = "/databus"
              port   = "8625"
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
              path   = "/databus"
              port   = "8625"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
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
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = local.databus_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.databus_server_resources["rolling_update_max_surge"]
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

resource "kubernetes_service" "databus_server" {
  count = var.has_databus_server ? 1 : 0
  metadata {
    name      = "databus-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "databus-server-8625-8625"
      protocol    = "TCP"
      port        = 8625
      target_port = "8625"
    }


    selector = {
      app = "databus-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "databus_server_autoscaler" {
  count = var.has_databus_server ? 1 : 0
  metadata {
    name      = "databus-server-autoscaler-v2beta2"
    namespace = var.namespace
  }

  spec {
    min_replicas = local.databus_server_resources["replicas"]
    max_replicas = local.databus_server_resources["max_replicas"]

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "databus-server"
    }
    target_cpu_utilization_percentage = local.databus_server_resources["cpu_utilization_percentage"]
  }
}

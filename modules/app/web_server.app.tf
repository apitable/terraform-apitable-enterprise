resource "kubernetes_deployment" "web_server" {
  wait_for_rollout = var.is_wait
  count            = var.has_web_server ? 1 : 0
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "web-server"
    namespace = var.namespace

    labels = {
      app = "web-server"
    }

  }

  spec {
    replicas = local.web_server_resources["replicas"]

    selector {
      match_labels = {
        app = "web-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "web-server"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
          "configmap.web-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.web_server_env.data)) : "not_enabled"
        }
      }

      spec {

        node_selector = var.node_selector

        init_container {
          name              = "init-settings"
          image             = "${var.registry}/${lookup(local.image_namespaces, "init_settings")}/init-settings:${lookup(local.image_tags, "init_settings")}"
          image_pull_policy = var.image_pull_policy
          command = [
            "sh", "-c",
            "[ -d /settings ] && cp -afr /settings/* /tmp/vika"
          ]
          security_context {
            allow_privilege_escalation = false
            run_as_user                = "0"
          }
          volume_mount {
            mount_path = "/tmp/vika"
            name       = "settings"
            sub_path   = "settings"
          }
        }

        volume {
          name = "settings"
          empty_dir {}
        }

        container {
          name  = "web-server"
          image = "${var.registry}/${lookup(local.image_namespaces, "web_server")}/web-server:${lookup(local.image_tags, "web_server")}"

          env_from {
            config_map_ref {
              name = "web-server-env"
            }
          }

          volume_mount {
            mount_path = "/tmp/vika"
            name       = "settings"
            sub_path   = "settings"
          }

          resources {
            requests = {
                cpu    = local.web_server_resources["requests_cpu"]              //@add_tf_local
                memory = local.web_server_resources["requests_memory"]           //@add_tf_local
            }
            limits = {
                cpu      = local.web_server_resources["limits_cpu"]              //@add_tf_local
                memory   = local.web_server_resources["limits_memory"]           //@add_tf_local
            }
          }

          # Detect whether the application is healthy, delete and restart the container if it is unhealthy
          liveness_probe {
            http_get {
              path   = "/api/actuator/health"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 45
            success_threshold     = 1
            failure_threshold     = 3
          }

          # Detect whether the application is ready and in normal service state, if it is not normal, it will not receive traffic from Kubernetes Service
          readiness_probe {
            http_get {
              path   = "/api/actuator/health"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 15
            success_threshold     = 1
            failure_threshold     = 3
          }

          # Detect whether the application is started. If it is not ready within the failureThreshold*periodSeconds period, the application process will be restarted
          startup_probe {
            http_get {
              path   = "/api/actuator/health"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          command = local.web_server_resources["command"]

          security_context {
            allow_privilege_escalation = false
            run_as_user                = "0"
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
        max_unavailable = local.web_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.web_server_resources["rolling_update_max_surge"]
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

locals {
  default_backend_server_resources = {
    replicas                       = "1"
    requests_cpu                   = "100m"
    requests_memory                = "1024Mi"
    limits_cpu                     = "2000m"
    limits_memory                  = "4096Mi"
    rolling_update_max_unavailable = "25%"
    rolling_update_max_surge       = "25%"
  }
}

locals {
  backend_server_resources = merge(local.default_backend_server_resources, lookup(var.resources, "backend_server", {}))
}

variable "backend_server_depends_on" {
  //type    = string
  default = ""
}
resource "kubernetes_deployment" "backend_server" {
  wait_for_rollout = var.is_wait
  depends_on = [
    kubernetes_namespace.this,
    var.backend_server_depends_on
  ]

  count = var.has_backend_server ? 1 : 0
  metadata {
    name      = "backend-server"
    namespace = var.namespace

    labels = {
      app = "backend-server"
    }

  }

  spec {
    replicas = local.backend_server_resources["replicas"]

    selector {
      match_labels = {
        app = "backend-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend-server"
          # sa-app = "backend-server-filebeat"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
          "configmap.backend-server-env/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.backend_server_env.data)) : "not_enabled"
        }
      }

      spec {
        // 神策日志目录存放于 empty_dir {}
        volume {
          name = "log-path"
          empty_dir {}
        }

        //Configuration of filebeat.
        volume {
          name = "filebeat-config-in"

          config_map {
            name = "filebeat-config-in"
          }
        }

        node_selector = var.node_selector

        //Initialize the container and create the structure of the My SQL database.
        init_container {
          name              = "init-db"
          image             = "${var.registry}/${lookup(local.image_namespaces, "init_db")}/init-db:${lookup(local.image_tags, "init_db")}"
          image_pull_policy = var.image_pull_policy
          # command = ["sh", "-c", "chmod -R 777 /workdir && echo InitContainerFinished!"]
          env {
            name  = "DB_HOST"
            value = lookup(local.env_config, "MYSQL_HOST", "localhost")
          }
          env {
            name  = "DB_PORT"
            value = lookup(local.env_config, "MYSQL_PORT", "3306")
          }
          env {
            name  = "DB_NAME"
            value = lookup(local.env_config, "MYSQL_DATABASE", "")
          }
          env {
            name  = "DB_USERNAME"
            value = lookup(local.env_config, "MYSQL_USERNAME", "root")
          }
          env {
            name  = "DB_PASSWORD"
            value = sensitive(lookup(local.env_config, "MYSQL_PASSWORD", ""))
          }
          env {
            name  = "DATABASE_TABLE_PREFIX"
            value = local.env_config["DATABASE_TABLE_PREFIX"]
          }
          env {
            name  = "ACTION"
            value = "update"
          }

        }
        init_container {
          name              = "init-db-enterprise"
          image             = "${var.registry}/${lookup(local.image_namespaces, "init_db")}/init-db-enterprise:${lookup(local.image_tags, "init_db")}"
          image_pull_policy = var.image_pull_policy
          # command = ["sh", "-c", "chmod -R 777 /workdir && echo InitContainerFinished!"]
          env {
            name  = "EDITION"
            value = lookup(local.backend_server_env, "EDITION", "vika-saas")
          }
          env {
            name  = "DB_HOST"
            value = lookup(local.env_config, "MYSQL_HOST", "localhost")
          }
          env {
            name  = "DB_PORT"
            value = lookup(local.env_config, "MYSQL_PORT", "3306")
          }
          env {
            name  = "DB_NAME"
            value = lookup(local.env_config, "MYSQL_DATABASE", "")
          }
          env {
            name  = "DB_USERNAME"
            value = lookup(local.env_config, "MYSQL_USERNAME", "root")
          }
          env {
            name  = "DB_PASSWORD"
            value = sensitive(lookup(local.env_config, "MYSQL_PASSWORD", ""))
          }
          env {
            name  = "DATABASE_TABLE_PREFIX"
            value = local.env_config["DATABASE_TABLE_PREFIX"]
          }
          env {
            name  = "ACTION"
            value = "update"
          }

        }

        container {
          name              = "backend-server"
          image             = "${var.registry}/${lookup(local.image_namespaces, "backend_server")}/backend-server:${lookup(local.image_tags, "backend_server")}"
          image_pull_policy = var.image_pull_policy
          env_from {
            config_map_ref {
              name = "backend-server-env"
            }
          }


          resources {
            requests = {
              cpu = local.backend_server_resources["requests_cpu"]
               memory = local.backend_server_resources["requests_memory"]    //@add_tf_local
            }
            limits = {
                cpu      = local.backend_server_resources["limits_cpu"]        //@add_tf_local
                memory   = local.backend_server_resources["limits_memory"]     //@add_tf_local
            }
          }

          liveness_probe {
            http_get {
              path   = "/api/v1/actuator/health/liveness"
              port   = "8081"
              scheme = "HTTP"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 3
            period_seconds        = 30
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path   = "/api/v1/actuator/health/readiness"
              port   = "8081"
              scheme = "HTTP"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 3
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          startup_probe {
            http_get {
              path   = "/api/v1/actuator/health/readiness"
              port   = "8081"
              scheme = "HTTP"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 3
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          #Sensors data log storage location.
          volume_mount {
            name       = "log-path"
            mount_path = "/logs/sensors"
          }

          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
        }

        //Filebeat sidecar, collecting Sensors data logs
        dynamic "container" {
          for_each = var.has_sensors_filebeat ? [1] : []
          content {
            name  = "filebeat"
            image = "${var.registry}/vikadata/beats/filebeat:7.2.0"
            args  = ["-c", "/etc/filebeat.yml", "-e"]

            volume_mount {
              name       = "filebeat-config-in"
              read_only  = true
              mount_path = "/etc/filebeat.yml"
              sub_path   = "filebeat.yml"
            }

            volume_mount {
              name       = "log-path"
              read_only  = true
              mount_path = "/logs/sensors"
            }
          }
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
        max_unavailable = local.backend_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.backend_server_resources["rolling_update_max_surge"]
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

resource "kubernetes_service" "backend_server" {
  count = var.has_backend_server ? 1 : 0
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "backend-server"
    namespace = var.namespace
  }

  spec {
    port {
      name        = "backend-server-8081-8081"
      protocol    = "TCP"
      port        = 8081
      target_port = "8081"
    }
    port {
      name        = "backend-server-8083-8083"
      protocol    = "TCP"
      port        = 8083
      target_port = "8083"
    }

    selector = {
      app = "backend-server"
    }

    type             = "ClusterIP"
    session_affinity = "None"
    ip_families      = ["IPv4"]
  }
}

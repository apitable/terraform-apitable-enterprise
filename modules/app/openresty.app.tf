# env
locals {
  default_openresty_resources = {
    replicas                       = "1"
    requests_cpu                   = "250m"
    requests_memory                = "512Mi"
    limits_cpu                     = "2000m"
    limits_memory                  = "4096Mi"
    rolling_update_max_unavailable = "25%"
    rolling_update_max_surge       = "25%"
    lifecycle_post_start_command = [
      "/bin/sh", "-c",
      "ls"
    ]
  }
}

locals {
  openresty_resources = merge(local.default_openresty_resources, lookup(var.resources, "openresty", {}))
}

resource "kubernetes_deployment" "openresty" {
  wait_for_rollout = var.is_wait
  lifecycle {
    ignore_changes = [
      spec[0].template[0].spec[0].affinity,
      metadata[0].annotations,
      spec[0].template[0].metadata[0].annotations
    ]
  }
  count = var.has_openresty ? 1 : 0
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "openresty"
    namespace = var.namespace

    labels = {
      app = "openresty"
    }

  }

  spec {
    replicas = local.openresty_resources["replicas"]

    selector {
      match_labels = {
        app = "openresty"
      }
    }

    template {
      metadata {
        labels = {
          app = "openresty"
        }

        annotations = {
          # redeploy-timestamp = "1655996168285"
          "configmap.openresty-config/reload" = var.has_auto_reloaded_config_map ? sha1(jsonencode(kubernetes_config_map.openresty_config.data)) : "not_enabled"
        }
      }

      spec {

        node_selector = var.node_selector

        volume {
          name = "volume-1655994097224"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655994376906"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995785123"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995785124"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995807238"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995833183"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }


        volume {
          name = "volume-1655995925041"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995926172"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995964531"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995964532"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995965437"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995965438"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995965439"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-1655995965440"

          config_map {
            name         = "openresty-config"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-ssl-certs"

          secret {
            secret_name  = "openresty-ssl-certs"
            default_mode = "0644"
          }
        }

        volume {
          name = "volume-extend-ssl-certs"

          secret {
            secret_name  = var.has_extend_tls ? "openresty-extend-ssl-certs" : "openresty-ssl-certs"
            default_mode = "0644"
          }
        }

        container {
          name = "openresty"
          # 重打包镜像，增加了resty-http 模块
          image = "${var.registry}/${lookup(local.image_namespaces, "openresty")}/openresty:1.21.4.1-http-fat"

          resources {
            requests = {
               cpu    = local.openresty_resources["requests_cpu"]              //@add_tf_local
               memory = local.openresty_resources["requests_memory"]           //@add_tf_local
            }
            limits = {
               cpu      = local.openresty_resources["limits_cpu"]              //@add_tf_local
               memory   = local.openresty_resources["limits_memory"]           //@add_tf_local
            }
          }
          #增加读取大表灰度功能
          lifecycle {
            post_start {
              exec {
                command = local.openresty_resources["lifecycle_post_start_command"]
              }
            }
          }

          volume_mount {
            name       = "volume-1655994097224"
            mount_path = "/usr/local/openresty/nginx/conf/nginx.conf"
            sub_path   = "nginx.conf"
          }

          volume_mount {
            name       = "volume-1655994097224"
            mount_path = "/etc/nginx/conf.d/vhost/ssl_host.conf"
            sub_path   = var.enable_ssl ? "ssl-host.conf" : "ssl-default.conf"
          }

          volume_mount {
            name       = "volume-1655994097224"
            mount_path = "/etc/nginx/conf.d/vhost/openresty_extra_config.conf"
            sub_path   = "openresty_extra_config.conf"
          }

          volume_mount {
            mount_path = "/etc/nginx/conf.d/certs/tls.crt"
            name       = "volume-ssl-certs"
            sub_path   = "tls.crt"
          }


          volume_mount {
            mount_path = "/etc/nginx/conf.d/certs/tls.key"
            name       = "volume-ssl-certs"
            sub_path   = "tls.key"
          }

          volume_mount {
            mount_path = "/etc/nginx/conf.d/certs/extend-tls.crt"
            name       = "volume-extend-ssl-certs"
            sub_path   = "tls.crt"
          }


          volume_mount {
            mount_path = "/etc/nginx/conf.d/certs/extend-tls.key"
            name       = "volume-extend-ssl-certs"
            sub_path   = "tls.key"
          }

          volume_mount {
            name       = "volume-1655994376906"
            mount_path = "/etc/nginx/conf.d/upstream/ups-socket-server.conf"
            sub_path   = "ups-socket-server.conf"
          }

          volume_mount {
            name       = "volume-1655995785123"
            mount_path = "/etc/nginx/conf.d/upstream/ups-room-server.conf"
            sub_path   = "ups-room-server.conf"
          }

          volume_mount {
            name       = "volume-1655995785124"
            mount_path = "/etc/nginx/conf.d/upstream/ups-fusion-server.conf"
            sub_path   = "ups-fusion-server.conf"
          }

          volume_mount {
            name       = "volume-1655995807238"
            mount_path = "/etc/nginx/conf.d/upstream/ups-backend-server.conf"
            sub_path   = "ups-backend-server.conf"
          }

          volume_mount {
            name       = "volume-1655995833183"
            mount_path = "/etc/nginx/conf.d/upstream/ups-web-server.conf"
            sub_path   = "ups-web-server.conf"
          }

          volume_mount {
            name       = "volume-1655995833183"
            mount_path = "/etc/nginx/conf.d/upstream/ups-ai-server.conf"
            sub_path   = "ups-ai-server.conf"
          }
          volume_mount {
            name       = "volume-1655995965440"
            mount_path = "/etc/nginx/conf.d/server/ai-server.conf"
            sub_path   = "ai-server.conf"
          }

          volume_mount {
            name       = "volume-1655995833183"
            mount_path = "/etc/nginx/conf.d/upstream/ups-databus-server.conf"
            sub_path   = "ups-databus-server.conf"
          }

          volume_mount {
            name       = "volume-1655995965440"
            mount_path = "/etc/nginx/conf.d/server/databus-server.conf"
            sub_path   = "databus-server.conf"
          }
          volume_mount {
            name       = "volume-1655995925041"
            mount_path = "/etc/nginx/conf.d/server/web-server.conf"
            sub_path   = "web-server.conf"
          }

          volume_mount {
            name       = "volume-1655995926172"
            mount_path = "/etc/nginx/conf.d/server/backend-server.conf"
            sub_path   = "backend-server.conf"
          }

          volume_mount {
            name       = "volume-1655995964531"
            mount_path = "/etc/nginx/conf.d/server/room-server.conf"
            sub_path   = "room-server.conf"
          }

          volume_mount {
            name       = "volume-1655995964532"
            mount_path = "/etc/nginx/conf.d/server/fusion-server.conf"
            sub_path   = "fusion-server.conf"
          }

          volume_mount {
            name       = "volume-1655995965437"
            mount_path = "/etc/nginx/conf.d/server/socket-server.conf"
            sub_path   = "socket-server.conf"
          }

          volume_mount {
            name       = "volume-1655995965438"
            mount_path = "/etc/nginx/conf.d/server/job-admin-server.conf"
            sub_path   = "job-admin-server.conf"
          }

          volume_mount {
            name       = "volume-1655995965439"
            mount_path = "/etc/nginx/conf.d/upstream/ups-job-admin-server.conf"
            sub_path   = "ups-job-admin-server.conf"
          }

          volume_mount {
            name       = "volume-1655995965440"
            mount_path = "/etc/nginx/conf.d/server/lbs-amap.conf"
            sub_path   = "lbs-amap.conf"
          }

          volume_mount {
            name       = "volume-1655995965440"
            mount_path = "/etc/nginx/conf.d/server/static-proxy.conf"
            sub_path   = "static-proxy.conf"
          }

          volume_mount {
            name       = "volume-1655995965440"
            mount_path = "/etc/nginx/conf.d/server/imageproxy-server.conf"
            sub_path   = var.has_imageproxy_server ? "imageproxy-server.conf" : "blank.config"
          }

          volume_mount {
            name       = "volume-1655995965440"
            mount_path = "/usr/local/openresty/nginx/html/robots.txt"
            sub_path   = var.disallow_robots ? "disable_robots.txt" : "enable_robots.txt"
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "80"
              scheme = "HTTP"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 1
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = "80"
              scheme = "HTTP"
            }

            initial_delay_seconds = 5
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
        max_unavailable = "25%"
        max_surge       = "25%"
      }
    }

    revision_history_limit    = 10
    progress_deadline_seconds = 600
  }
}

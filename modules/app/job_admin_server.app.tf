# env
locals {
  default_job_admin_server_resources = {
    replicas                       = "1"
    requests_cpu                   = "100m"
    requests_memory                = "512Mi"
    limits_cpu                     = "500m"
    limits_memory                  = "1024Mi"
    rolling_update_max_unavailable = "25%"
    rolling_update_max_surge       = "25%"
  }
}
locals {
  job_admin_server_env = merge(local.env_config, {

    # Job Admin Server + Executor
    # (xxl)JOB（The variable values of the dispatch center and the executor must be consistent）
    JOB_ACCESS_TOKEN  = "onJvanLmSE3CqotjNp8hb7WRolpM1pdL"
    JOB_ADMIN_ADDRESS = "http://job-admin-server:8080/job-admin"

    # SMTP Email push configuration
    MAIL_HOST     = "smtp.feishu.cn"
    MAIL_USERNAME = "email-server@vikadata.com"
    MAIL_PASSWORD = "Qwer123456"

  }, lookup(var.envs, "job_admin_server", {}))

  job_admin_server_resources = merge(local.default_job_admin_server_resources, lookup(var.resources, "job_admin_server", {}))
}

resource "kubernetes_deployment" "job_admin_server" {
  wait_for_rollout = var.is_wait
  count            = var.has_job_admin_server ? 1 : 0
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "job-admin-server"
    namespace = var.namespace

    labels = {
      app = "job-admin-server"
    }

    annotations = {
      # "deployment.kubernetes.io/revision" = "23"
    }
  }

  spec {
    replicas = local.job_admin_server_resources["replicas"]

    selector {
      match_labels = {
        app = "job-admin-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "job-admin-server"
        }

        annotations = {
          # redeploy-timestamp = "1655781881366"
        }
      }

      spec {
        container {
          name  = "job-admin-server"
          image = "${var.registry}/${lookup(local.image_namespaces, "job_admin_server")}/xxl-job-admin:2.3.0"

          env {
            name  = "PARAMS"
            value = "--server.servlet.context-path=/job-admin --spring.datasource.url=jdbc:mysql://${lookup(local.job_admin_server_env, "MYSQL_HOST", "localhost")}:${lookup(local.job_admin_server_env, "MYSQL_PORT", "3306")}/${lookup(local.job_admin_server_env, "MYSQL_DATABASE", "")}?Unicode=true&characterEncoding=UTF-8  --spring.datasource.username=${lookup(local.job_admin_server_env, "MYSQL_USERNAME", "root")} --spring.datasource.password=${sensitive(lookup(local.job_admin_server_env, "MYSQL_PASSWORD", ""))} --xxl.job.accessToken=${lookup(local.job_admin_server_env, "JOB_ACCESS_TOKEN", "")} --spring.mail.host=${lookup(local.job_admin_server_env, "MAIL_HOST", "root")} --spring.mail.port=465  --spring.mail.username=${lookup(local.job_admin_server_env, "MAIL_USERNAME", "root")} --spring.mail.from=${lookup(local.job_admin_server_env, "MAIL_USERNAME", "root")} --spring.mail.password=${lookup(local.job_admin_server_env, "MAIL_PASSWORD", "")}  --spring.mail.properties.mail.smtp.socketFactory.port=465"
          }

          resources {
            requests = {
              cpu = local.job_admin_server_resources["requests_cpu"]
               memory = local.job_admin_server_resources["requests_memory"]     //@add_tf_local
            }
            limits = {
                cpu      = local.job_admin_server_resources["limits_cpu"]          //@add_tf_local
                memory   = local.job_admin_server_resources["limits_memory"]       //@add_tf_local
            }
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
        max_unavailable = local.job_admin_server_resources["rolling_update_max_unavailable"]
        max_surge       = local.job_admin_server_resources["rolling_update_max_surge"]
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

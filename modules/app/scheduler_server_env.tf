locals {
  scheduler_server_env = merge(local.env_config, {
    ENABLE_SCHED     = "true"
    APPLICATION_NAME = "SCHEDULE_SERVER"
    INSTANCE_COUNT   = "1"
    LOG_LEVEL        = "info"
    BACKEND_BASE_URL = "http://backend-server:8081/api/v1/"
    SOCKET_GRPC_URL  = "socket-server:3007"
    OSS_TYPE         = "QNY1"
    ZIPKIN_ENABLED   = "false"
  }, lookup(var.envs, "scheduler_server", {}))
}

resource "kubernetes_config_map" "scheduler_server_env" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "scheduler-server-env"
    namespace = var.namespace

    annotations = {
    }
  }

  data = local.scheduler_server_env
}

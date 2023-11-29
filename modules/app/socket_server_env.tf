locals {
  socket_server_env = merge(local.env_config, {
    WEB_SOCKET_CHANNEL_ENV = var.namespace
    APPLICATION_NAME       = "SOCKET_SERVER"
    ENABLE_SOCKET          = "true"
    SERVER_PORT            = "3001"

    INSTANCE_COUNT = "1"
    LOG_LEVEL      = "info"

    NEST_HEALTH_CHECK_CRON_EXPRESSION = "*/3 * * * * *"
    NEST_HEALTH_CHECK_TIMEOUT         = "1000"
    ROOM_GRPC_URL                     = "room-server:3334"
    BACKEND_GRPC_URL                  = "backend-server:8083"
    GRPC_TIMEOUT_MAX_TIMES            = "3"
    NODE_MEMORY_RATIO                 = "80"

  }, lookup(var.envs, "socket_server", {}))
}

resource "kubernetes_config_map" "socket_server_env" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "socket-server-env"
    namespace = var.namespace

    annotations = {
    }
  }

  data = local.socket_server_env
}

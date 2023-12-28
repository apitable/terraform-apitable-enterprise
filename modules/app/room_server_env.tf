locals {
  room_server_env = merge(local.env_config, {
    WEB_SOCKET_CHANNEL_ENV      = var.namespace
    APPLICATION_NAME            = "ROOM_SERVER"
    SERVER_PORT                 = "3333"
    INSTANCE_COUNT              = "1"
    LOG_LEVEL                   = "info"
    BACKEND_BASE_URL            = "http://backend-server:8081/api/v1/"
    SOCKET_GRPC_URL             = "socket-server:3007"
    OSS_HOST                    = "/assets"
    OSS_TYPE                    = "QNY1"
    ZIPKIN_ENABLED              = "false"
    ROBOT_OFFICIAL_SERVICE_SLUG = "vika"
    DEFAULT_LANGUAGE            = "en-US"
    ENABLE_HOCUSPOCUS           = var.has_document_server ? "false" : "true"
    # register mq consumer
    ENABLE_QUEUE_CONSUMER_WORKER = "true"
  }, lookup(var.envs, "room_server", {}))
}

resource "kubernetes_config_map" "room_server_env" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "room-server-env"
    namespace = var.namespace

    annotations = {
    }
  }

  data = local.room_server_env
}

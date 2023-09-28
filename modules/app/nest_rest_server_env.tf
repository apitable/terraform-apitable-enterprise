locals {
  nest_rest_server_env = merge(local.env_config, {
    WEB_SOCKET_CHANNEL_ENV      = var.namespace
    APPLICATION_NAME            = "NEST_REST_SERVER"
    INSTANCE_COUNT              = "1"
    LOG_LEVEL                   = "info"
    BACKEND_BASE_URL            = "http://backend-server:8081/api/v1/"
    SOCKET_GRPC_URL             = "socket-server:3007"
    OSS_HOST                    = "/assets"
    OSS_TYPE                    = "QNY1"
    ZIPKIN_ENABLED              = "false"
    ROBOT_OFFICIAL_SERVICE_SLUG = "vika"
  }, lookup(var.envs, "nest_rest_server", {}))
}

resource "kubernetes_config_map" "nest_rest_server_env" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "nest-rest-server-env"
    namespace = var.namespace

    annotations = {
    }
  }


  data = local.nest_rest_server_env
}

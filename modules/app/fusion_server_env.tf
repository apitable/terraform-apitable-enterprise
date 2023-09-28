locals {
  fusion_server_env = merge(local.env_config, {
    APPLICATION_NAME            = "FUSION_SERVER"
    INSTANCE_COUNT              = "1"
    LOG_LEVEL                   = "info"
    BACKEND_BASE_URL            = "http://backend-server:8081/api/v1/"
    SOCKET_GRPC_URL             = "socket-server:3007"
    OSS_HOST                    = "/assets"
    OSS_TYPE                    = "QNY1"
    OSS_CACHE_TYPE              = ""
    ZIPKIN_ENABLED              = "false"
    ROBOT_OFFICIAL_SERVICE_SLUG = "vika"
  }, lookup(var.envs, "fusion_server", {}))
}

resource "kubernetes_config_map" "fusion_server_env" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "fusion-server-env"
    namespace = var.namespace

    annotations = {
    }
  }

  data = local.fusion_server_env
}

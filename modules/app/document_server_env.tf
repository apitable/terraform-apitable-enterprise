locals {
  document_server_env = merge(local.env_config, {
    ENABLE_HOCUSPOCUS           = "true"
    APPLICATION_NAME            = "DOCUMENT_SERVER"
    INSTANCE_COUNT              = "1"
    LOG_LEVEL                   = "info"
    BACKEND_BASE_URL            = "http://backend-server:8081/api/v1/"
    SOCKET_GRPC_URL             = "socket-server:3007"
    OSS_HOST                    = "/assets"
    OSS_TYPE                    = "QNY1"
    ZIPKIN_ENABLED              = "false"
  }, lookup(var.envs, "document_server", {}))
}

resource "kubernetes_config_map" "document_server_env" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "document-server-env"
    namespace = var.namespace

    annotations = {
    }
  }


  data = local.document_server_env
}

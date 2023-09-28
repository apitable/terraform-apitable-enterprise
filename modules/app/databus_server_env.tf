locals {
  databus_server_env = merge(local.env_config, {
    WEB_SOCKET_CHANNEL_ENV = var.namespace
    BACKEND_BASE_URL       = "http://backend-server:8081/api/v1/"
    OSS_HOST               = "/assets"
  }, lookup(var.envs, "databus_server", {}))
}

resource "kubernetes_config_map" "databus_server_env" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "databus-server-env"
    namespace = var.namespace

    annotations = {
    }
  }

  data = local.databus_server_env
}

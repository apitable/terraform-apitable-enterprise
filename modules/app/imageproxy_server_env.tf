locals {
  imageproxy_server_env = merge(local.env_config, {
    BASEURL          = "http://minio:9000",
    TZ               = "Asia/Shanghai",
    IMAGEPROXY_CACHE = "/tmp/imageproxy"
  }, lookup(var.envs, "imageproxy_server", {}))
}

resource "kubernetes_config_map" "imageproxy_server_env" {

  count = var.has_imageproxy_server ? 1 : 0

  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "imageproxy-server-env"
    namespace = var.namespace

    annotations = {
    }
  }

  data = local.imageproxy_server_env
}

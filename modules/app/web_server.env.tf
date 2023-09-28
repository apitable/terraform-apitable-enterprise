locals {
  web_server_env = merge(local.env_config, {

    API_PROXY        = "http://backend-server:8081"
    BACKEND_INFO_URL = "http://backend-server:8081/api/v1/client/info"
    TEMPLATE_PATH    = "./static/web_build/index.html"
    WEB_SERVER_PORT  = "8080"


  }, lookup(var.envs, "web_server", {}))
}

resource "kubernetes_config_map" "web_server_env" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "web-server-env"
    namespace = var.namespace

    annotations = {
    }
  }

  data = local.web_server_env
}

//Declare the minimum resource to start the service.
locals {
  default_web_server_resources = {
    replicas = "1"
    // ⚠️ Note: requests are required resources, not limits limit resources 200m = 0.2CPU, 1000m = 1CPU, 1 = 1CPU, 0.1 = 100m
    // There is currently no setting for limits
    // see: https://kubesphere.io/zh/blogs/deep-dive-into-the-k8s-request-and-limit
    requests_cpu = "200m"
    // Mi，Gi
    requests_memory                = "512Mi"
    limits_cpu                     = "1000m"
    limits_memory                  = "2048Mi"
    rolling_update_max_unavailable = "0%"
    rolling_update_max_surge       = "25%"
    //Change startup items and inject environment variables
    command = [
      "/bin/sh", "-c",
      "[ -f /tmp/vika/run.sh ] &&  sh /tmp/vika/run.sh ; node server.js"
    ]
  }
}
// 合并单独命名空间（环境）声明的资源参数
locals {
  web_server_resources = merge(local.default_web_server_resources, lookup(var.resources, "web_server", {}))
}

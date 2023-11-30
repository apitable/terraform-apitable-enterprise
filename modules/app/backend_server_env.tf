locals {
  backend_server_env = merge(local.env_config, {
    LOGGER_MAX_HISTORY_DAYS = 1

    CORS_ORIGINS   = "*"
    TEMPLATE_SPACE = "spcNTxlv8Drra"

    SOCKET_DOMAIN     = "http://socket-server:3001/socket"
    OPEN_REDIRECT_URI = "https://integration.vika.ltd/api/v1/wechat/open/getQueryAuth"
    FEISHU_APP_ENABLE = "true"

    SPRINGFOX_ENABLED = "true"
    SWAGGER_ENABLED   = "true"
    DECORATOR_ENABLED = "true"
    ZIPKIN_ENABLED    = "false"


    # GRPC
    NEST_GRPC_ADDRESS       = "static://room-server:3334"
    BACKEND_GRPC_PORT       = "8083"



    # socketio starter
    SOCKET_URL                   = "http://socket-server:3002"
    SOCKET_RECONNECTION_ATTEMPTS = "10"
    SOCKET_RECONNECTION_DELAY    = "500"
    SOCKET_TIMEOUT               = "5000"

    # oss starter
    OSS_ENABLED = "true"






    # IDaaS starter
    IDAAS_ENABLED = "false"

    # Enterprise Env
    SESSION_NAMESPACE = "vikadata:session"
    DEFAULT_LOCALE    = "zh-CN"
    EMAIL_PERSONAL    = "维格表"

    # user cooling-off time, unit: day
    COOLING_OFF_PERIOD = 30

    # scheduler
    # close user job cron string, run at 0:00 every day
    CLOSE_PAUSED_USER_CRON = "0 0 0 * * ?"
    # disable heartbeat job cron
    HEARTBEAT_CRON = "-"

    SKIP_AUTOMATION_RUN_NUM_VALIDATE = "true"

  }, lookup(var.envs, "backend_server", {}))
}

resource "kubernetes_config_map" "backend_server_env" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "backend-server-env"
    namespace = var.namespace

    annotations = {
    }
  }

  data = local.backend_server_env
}

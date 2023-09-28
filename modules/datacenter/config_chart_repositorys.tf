
locals {
  chart_repositrys = merge({
    mysql         = var.chart_repository
    elasticsearch = var.chart_repository
    filebeat      = var.chart_repository
    kafka         = var.chart_repository
    kibana        = var.chart_repository
    minio         = var.chart_repository
    mongodb       = var.chart_repository
    postgresql    = var.chart_repository
    rabbitmq      = var.chart_repository
    redis         = var.chart_repository
    zookeeper     = var.chart_repository
  }, var.chart_repositorys)
}

locals {
  chart_registrys = merge({
    mysql         = var.chart_registry
    elasticsearch = var.chart_registry
    filebeat      = var.chart_registry
    kafka         = var.chart_registry
    kibana        = var.chart_registry
    minio         = var.chart_registry
    mongodb       = var.chart_registry
    postgresql    = var.chart_registry
    rabbitmq      = var.chart_registry
    redis         = var.chart_registry
    zookeeper     = var.chart_registry
  }, var.chart_registrys)
}
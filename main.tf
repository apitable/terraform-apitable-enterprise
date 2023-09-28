
locals {
  datacenter_namespace     = var.has_datacenter ? var.data_namespace : var.namespace
  all_namespace            = [var.namespace, local.datacenter_namespace]
  image_init_db            = "${var.regcred.registry_server}/${lookup(var.image_namespaces, "init_db", "vikadata/vika")}/init-db:${lookup(var.image_tags, "init_db", "latest")}"
  image_init_enterprise_db = "${var.regcred.registry_server}/${lookup(var.image_namespaces, "init_db", "vikadata/vika")}/init-db:${lookup(var.image_tags, "init_db", "latest")}"
  image_init_appdata       = "${var.regcred.registry_server}/${lookup(var.image_namespaces, "init_appdata", "vikadata/apitable-ce")}/init-appdata:${lookup(var.image_tags, "init_appdata", "latest")}"


  env_config = merge({
    # Basic storage configuration.
    MYSQL_DATABASE        = "apitable"
    MYSQL_HOST            = "mysql-primary.${local.datacenter_namespace}"
    MYSQL_PORT            = "3306"
    MYSQL_USERNAME        = "root"
    MYSQL_PASSWORD        = "apitable@com"
    DATABASE_TABLE_PREFIX = "apitable_"

    RABBITMQ_HOST     = "rabbitmq-headless.${local.datacenter_namespace}"
    RABBITMQ_PORT     = "5672"
    RABBITMQ_USERNAME = "apitable"
    RABBITMQ_PASSWORD = "apitable@com"
    RABBITMQ_VHOST    = "/"

    AWS_ACCESS_KEY    = "admin"
    AWS_ACCESS_SECRET = "apitable@com"
    AWS_ENDPOINT      = "http://minio.${local.datacenter_namespace}:9000"
    AWS_REGION        = "us-east-1"
    AWS_HOST          = "minio.${local.datacenter_namespace}"
    AWS_PORT          = "9000"

    REDIS_HOST     = "redis-master.${local.datacenter_namespace}"
    REDIS_PASSWORD = "apitable@com"

    # System parameter configuration.
    SENTRY_DSN               = ""
    SKIP_GLOBAL_WIDGET_AUDIT = "true"
    SKIP_USAGE_VERIFICATION  = "true"
    DOMAIN_NAME              = ""
    EDITION                  = "apitable-saas"
    ASSETS_URL               = "/assets"
    ASSETS_BUCKET            = "assets"
    OSS_HOST                 = "/assets"
  }, var.env)
}


module "apitable-app" {
  source = "./modules/app"

  namespace = var.namespace
  create_ns = var.create_ns

  depends_on = [
    module.apitable-datacenter
  ]

  # Image configuration 
  registry         = var.regcred.registry_server
  image_tag        = "latest"
  image_tags       = var.image_tags
  image_namespace  = var.image_namespace
  image_namespaces = var.image_namespaces

  has_databus_server           = false
  has_job_admin_server         = false
  has_imageproxy_server        = true
  has_auto_reloaded_config_map = true
  has_space_job_executor       = false
  has_bill_job_executor        = false
  has_cron_job                 = false
  has_sensors_filebeat         = false

  #Ensure that there is docker authentication when pulling images
  backend_server_depends_on    = kubernetes_secret_v1.regcred

  # service deployment configuration
  node_selector = var.node_selector
  resources     = var.resource

  # for service envs configuration
  env                  = local.env_config
  envs                 = var.envs
  public_assets_bucket = local.env_config.ASSETS_BUCKET

  default_server_host = "http://web-server"
  pricing_host        = "http://web-server"
  minio_host          = local.env_config.AWS_ENDPOINT


  #SLB and certs 
  has_load_balancer = var.has_load_balancer
  enable_ssl        = var.enable_ssl
  server_name       = var.server_name
  tls_crt           = var.tls_crt
  tls_key           = var.tls_key

}

module "apitable-datacenter" {
  count  = var.has_datacenter ? 1 : 0
  source = "./modules/datacenter"

  namespace        = local.datacenter_namespace
  create_ns        = var.create_ns
  chart_repository = var.chart_repository


  has_redis    = var.has_redis
  has_mysql    = var.has_mysql
  has_minio    = var.has_minio
  has_rabbitmq = var.has_rabbitmq

  default_storage_class_name = var.default_storage_class_name
  default_storage_size       = var.default_storage_size


  # Only effective during initial installation.
  mysql_init_database         = local.env_config.MYSQL_DATABASE
  mysql_default_root_password = local.env_config.MYSQL_PASSWORD
  minio_default_password      = local.env_config.AWS_ACCESS_SECRET
  rabbitmq_default_user       = local.env_config.RABBITMQ_USERNAME
  rabbitmq_default_password   = local.env_config.RABBITMQ_PASSWORD
  redis_default_password      = local.env_config.REDIS_PASSWORD
}

#
resource "kubernetes_secret_v1" "regcred" {
  for_each = toset(local.all_namespace)
  metadata {
    namespace = each.key
    name      = "regcred"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (var.regcred.registry_server) = {
          "username" = var.regcred.username
          "password" = var.regcred.password
          "auth"     = base64encode("${var.regcred.username}:${var.regcred.password}")
        }
      }
    })
  }
}

resource "helm_release" "init_data" {
  depends_on = [
    module.apitable-datacenter, 
    kubernetes_secret_v1.regcred
  ]
  name       = "init-data"
  chart      = "${path.module}/./charts/init-data"
  

  namespace  = var.namespace
  values = [
    <<EOT
global:
  imagePullSecrets:
    - name: regcred
mysql:
  host: ${local.env_config.MYSQL_HOST}
  port: ${local.env_config.MYSQL_PORT}
  username: ${local.env_config.MYSQL_USERNAME}
  password: ${local.env_config.MYSQL_PASSWORD}
  database: ${local.env_config.MYSQL_DATABASE}
  tablePrefix: ${local.env_config.DATABASE_TABLE_PREFIX}
  edition: ${local.env_config.EDITION}
redis:
  host: ${local.env_config.REDIS_HOST}
minio:
  host: ${local.env_config.AWS_HOST}
  port: ${local.env_config.AWS_PORT}
  accessKey: ${local.env_config.AWS_ACCESS_KEY}
  secretKey: ${local.env_config.AWS_ACCESS_SECRET}
  bucket: ${local.env_config.ASSETS_BUCKET}
initAppData:
  INIT_TEST_ACCOUNT_ENABLED: "true" 
  ASSETS_BUCKET: ${local.env_config.ASSETS_BUCKET}
images:
  initDataDb: ${local.image_init_db}
  initDataDbEnterprise: ${local.image_init_enterprise_db}
  initAppData: ${local.image_init_appdata}
  initCheck: ${var.init_check_image}
EOT
  ]
  force_update = true
  //nodeSelector 
  dynamic "set" {
    for_each = length(var.node_selector) > 2 ? [0] : []
    content {
      name  = "container.nodeSelector"
      value = yamlencode(var.node_selector)
    }
  }
  timeout = 1800
}

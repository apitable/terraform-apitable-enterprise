locals {
  //This is the global .env, it will be overwritten by the .env of other sub-services
  env_config = merge({
    VIKA_DATA_PATH = "/data/${var.namespace}"
    ENV            = var.namespace
    NODE_ENV       = "production"

    # MySQL
    MYSQL_HOST            = "mysql-server"
    MYSQL_PORT            = "3306"
    MYSQL_DATABASE        = "apitable"
    MYSQL_USERNAME        = "apitable"
    MYSQL_PASSWORD        = "nby9WQX.zuf_dvp@vhw"
    DATABASE_TABLE_PREFIX = "apitable_"

    # Redis
    REDIS_HOST     = "redis-master.apitable-datacenter"
    REDIS_PORT     = "6379"
    REDIS_PASSWORD = "UHWCWiuUMVyupqmW4cXV"
    REDIS_DB       = "0"

    # RabbitMQ
    RABBITMQ_HOST     = "rabbitmq-headless.apitable-datacenter"
    RABBITMQ_PORT     = "5672"
    RABBITMQ_USERNAME = "user"
    RABBITMQ_PASSWORD = "7r4HVvsrwP4kQjAgj8Jj"
    RABBITMQ_VHOST    = "/"

    # backend + nest
    SERVER_DOMAIN = ""

    ASSETS_URL    = "assets"
    ASSETS_BUCKET = "assets"
    EDITION       = "apitable-saas"

    CUSTOMER_NAME      = null
    STORAGE_CLASS_NAME = ""

    DATABUS_SERVER_BASE_URL = "http://databus-server:8625"

  }, var.env)
}

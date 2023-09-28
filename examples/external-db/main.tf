
module "apitable-enterprise" {

  source = "../../"
  #version = "x.x.x"

  namespace      = "apitable-enterprise"
  has_datacenter = false
  create_ns      = true

  // Environmental variables, such as databases, storage, etc.
  env = {
    MYSQL_DATABASE        = "apitable"
    MYSQL_HOST            = "mysql-host.example.com"
    MYSQL_PORT            = "3306"
    MYSQL_USERNAME        = "root"
    MYSQL_PASSWORD        = "apitable@com"
    DATABASE_TABLE_PREFIX = "apitable_"

    RABBITMQ_HOST     = "rabbitmq-host.example.com"
    RABBITMQ_PORT     = "5672"
    RABBITMQ_USERNAME = "apitable"
    RABBITMQ_PASSWORD = "apitable@com"
    RABBITMQ_VHOST    = "/"

    AWS_ACCESS_KEY    = "admin"
    AWS_ACCESS_SECRET = "apitable@com"
    AWS_ENDPOINT      = "http://aws-endpoint.example.com"
    AWS_REGION        = "us-east-1"
    AWS_HOST          = "aws-endpoint.example.com"
    AWS_PORT          = "9000"

    REDIS_HOST     = "redis-master.example.com"
    REDIS_PASSWORD = "apitable@com"
  }

  #Replace the storage_class of the cluster.
  default_storage_class_name = "<your-storage-class-name>"

  regcred = {
    registry_server = "<your-registry-server>"
    username        = "<your-username>"
    password        = "<your-password>"
  }

  image_tags = {
    backend_server = "latest-alpha"
    room_server    = "latest-alpha"
    #Others ..
  }

}
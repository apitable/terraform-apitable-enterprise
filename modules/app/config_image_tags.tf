//Image settings for all server
locals {
  image_tags = merge({
    backend_server     = var.image_tag
    room_server        = var.image_tag
    web_server         = var.image_tag
    socket_server      = var.image_tag
    migration_server   = var.image_tag
    init_db            = var.image_tag
    space_job_executor = var.image_tag
    imageproxy_server  = var.image_tag
    init_settings      = var.image_tag
    dingtalk_server    = var.image_tag
    ai_server          = var.image_tag
    databus_server     = var.image_tag
  }, var.image_tags)

  image_namespaces = merge({
    backend_server     = var.image_namespace
    room_server        = var.image_namespace
    web_server         = var.image_namespace
    socket_server      = var.image_namespace
    migration_server   = var.image_namespace
    init_db            = var.image_namespace
    space_job_executor = var.image_namespace
    imageproxy_server  = var.image_namespace
    init_settings      = var.image_namespace
    dingtalk_server    = var.image_namespace
    job_admin_server   = var.image_namespace
    openresty          = var.image_namespace
    ai_server          = var.image_namespace
    databus_server     = var.image_namespace
  }, var.image_namespaces)
}

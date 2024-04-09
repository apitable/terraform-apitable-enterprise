

variable "has_mysql" {
  type    = bool
  default = true
}

variable "mysql_init_disk_size" {
  type    = string
  default = "20Gi"
}

variable "mysql_init_database" {
  default = "apitable"
}

variable "mysql_default_root_password" {
  type    = string
  default = "6sg8vgDFcwWXP386EiZB"
}
locals {
  mysql_primary_my_cnf   = <<EOT
[mysqld]
default_authentication_plugin=mysql_native_password
skip-name-resolve
explicit_defaults_for_timestamp
basedir=/opt/bitnami/mysql
plugin_dir=/opt/bitnami/mysql/lib/plugin
port=3306
socket=/opt/bitnami/mysql/tmp/mysql.sock
datadir=/bitnami/mysql/data
tmpdir=/opt/bitnami/mysql/tmp
max_allowed_packet=16M
bind-address=0.0.0.0
pid-file=/opt/bitnami/mysql/tmp/mysqld.pid
log-error=/opt/bitnami/mysql/logs/mysqld.log
character-set-server=UTF8
collation-server=utf8_general_ci
slow_query_log=0
slow_query_log_file=/opt/bitnami/mysql/logs/mysqld.log
long_query_time=10.0
sql_mode=NO_ENGINE_SUBSTITUTION
max_allowed_packet=1073741824
mysqlx_max_allowed_packet=1073741824

[client]
port=3306
socket=/opt/bitnami/mysql/tmp/mysql.sock
default-character-set=UTF8
plugin_dir=/opt/bitnami/mysql/lib/plugin

[manager]
port=3306
socket=/opt/bitnami/mysql/tmp/mysql.sock
  EOT
  mysql_secondary_my_cnf = <<EOT
[mysqld]
default_authentication_plugin=mysql_native_password
skip-name-resolve
explicit_defaults_for_timestamp
basedir=/opt/bitnami/mysql
plugin_dir=/opt/bitnami/mysql/lib/plugin
port=3306
socket=/opt/bitnami/mysql/tmp/mysql.sock
datadir=/bitnami/mysql/data
tmpdir=/opt/bitnami/mysql/tmp
max_allowed_packet=1024M
bind-address=0.0.0.0
pid-file=/opt/bitnami/mysql/tmp/mysqld.pid
log-error=/opt/bitnami/mysql/logs/mysqld.log
character-set-server=UTF8
collation-server=utf8_general_ci
slow_query_log=0
slow_query_log_file=/opt/bitnami/mysql/logs/mysqld.log
long_query_time=10.0
sql_mode=NO_ENGINE_SUBSTITUTION
max_allowed_packet=1073741824
mysqlx_max_allowed_packet=1073741824
sort_buffer_size=2M
max_connections=10000

[client]
port=3306
socket=/opt/bitnami/mysql/tmp/mysql.sock
default-character-set=UTF8
plugin_dir=/opt/bitnami/mysql/lib/plugin

[manager]
port=3306
socket=/opt/bitnami/mysql/tmp/mysql.sock

  EOT
}

# resource "kubernetes_config_map" "mysql_config" {
#   metadata {
#     name      = "mysql-config"
#     namespace = var.namespace
#   }

#   data = {
#     "mysql.cnf" = local.mysql_primary_cnf
#   }
# }

variable "mysql_helm_override" {
  default = {}
  type = object({
    version = optional(string, null)
    values  = optional(list(any), [])
  })
}


// https://github.com/bitnami/charts/tree/master/bitnami/mysql
// Master-slave mode
resource "helm_release" "mysql" {
  count      = var.has_mysql ? 1 : 0
  name       = "mysql"
  repository = lookup(local.chart_repositrys, "mysql")
  chart      = "mysql"
  namespace  = var.namespace

  set {
    name  = "global.storageClass"
    value = var.default_storage_class_name
  }
  set {
    name  = "auth.rootPassword"
    value = sensitive(var.mysql_default_root_password)
  }
  set {
    name  = "architecture"
    value = "replication"
  }

  set {
    name  = "primary.persistence.size"
    value = var.mysql_init_disk_size
  }
  set {
    name  = "secondary.persistence.size"
    value = var.mysql_init_disk_size

  }

  set {
    name  = "auth.database"
    value = var.mysql_init_database
  }
  # my.cnf custom

  set {
    name  = "primary.configuration"
    value = local.mysql_primary_my_cnf
  }
  set {
    name  = "secondary.configuration"
    value = local.mysql_secondary_my_cnf
  }

  values = [for v in var.mysql_helm_override.values : yamlencode(v)]

  version = var.mysql_helm_override.version

}

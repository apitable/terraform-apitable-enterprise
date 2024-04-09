
resource "helm_release" "redis" {
  count      = var.has_redis ? 1 : 0
  name       = "redis"
  repository = lookup(local.chart_repositrys, "redis")
  chart      = "redis"
  namespace  = var.namespace

  set {
    name  = "architecture"
    value = "replication"
  }
  set {
    name  = "global.storageClass"
    value = var.default_storage_class_name
  }
  set {
    name  = "global.redis.password"
    value = sensitive(var.redis_default_password)
  }
  set {
    name  = "master.persistence.size"
    value = var.redis_disk_size
  }
  set {
    name  = "replica.persistence.size"
    value = var.redis_disk_size
  }
  set {
    name  = "sentinel.persistence.size"
    value = var.redis_disk_size
  }
  set {
    name  = "replica.replicaCount"
    value = 1
  }
  set {
    name  = "image.registry"
    value = lookup(local.chart_registrys, "redis")
  }
  set {
    name  = "global.imagePullSecrets[0]"
    value = "regcred"
  }

  values = [for v in var.redis_helm_override.values : yamlencode(v)]

  version = var.redis_helm_override.version
}

# # https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq

locals {
  rabbitmq_storage_class = var.rabbitmq_storage_class != "" ? var.rabbitmq_storage_class : var.default_storage_class_name
}

resource "helm_release" "rabbitmq" {
  count      = var.has_rabbitmq ? 1 : 0
  name       = "rabbitmq"
  repository = lookup(local.chart_repositrys, "rabbitmq")
  chart      = "rabbitmq"
  namespace  = var.namespace
  values = concat([
    <<EOT
global:
  storageClass: ${local.rabbitmq_storage_class}
  imagePullSecrets: ["regcred"]
persistence:
  size: 20Gi
auth:
  username: ${var.rabbitmq_default_user}
  password: ${var.rabbitmq_default_password}
image:
  registry: ${lookup(local.chart_registrys, "rabbitmq")}
EOT
    ],
    [for v in var.rabbitmq_helm_override.values : yamlencode(v)]
  )

  version = var.rabbitmq_helm_override.version
}

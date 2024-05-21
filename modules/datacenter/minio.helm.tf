# # https://github.com/bitnami/charts/tree/master/bitnami/minio

locals {
  minio_storage_class = var.minio_storage_class != "" ? var.minio_storage_class : var.default_storage_class_name
}

resource "helm_release" "minio" {

  count = var.has_minio ? 1 : 0

  name       = "minio"
  repository = lookup(local.chart_repositrys, "minio")
  chart      = "minio"
  namespace  = var.namespace
  values = concat([
    <<EOT
global:
  storageClass: ${local.minio_storage_class}
  imagePullSecrets: ["regcred"]
persistence:
  size: ${var.default_storage_size}
mode: standalone
auth:
  rootPassword: ${var.minio_default_password}
image:
  registry: "${lookup(local.chart_registrys, "minio")}"
EOT
    ],
    [for v in var.minio_helm_override.values : yamlencode(v)]
  )

  version = var.minio_helm_override.version
}

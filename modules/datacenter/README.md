
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.8.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.8.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.16.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.minio](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mysql](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.rabbitmq](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.redis](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_registry"></a> [chart\_registry](#input\_chart\_registry) | Default chart-registry address | `string` | `"docker.io"` | no |
| <a name="input_chart_registrys"></a> [chart\_registrys](#input\_chart\_registrys) | During initialization, you can freely control different container services, which registry to use, and if any, override the registry. Convention is recommended over configuration. | `map` | `{}` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Default helm warehouse address | `string` | `"https://charts.bitnami.com/bitnami"` | no |
| <a name="input_chart_repositorys"></a> [chart\_repositorys](#input\_chart\_repositorys) | When initializing the chart, you can freely control different container services, which repository is used respectively, and if there is one, override the repository. Convention is recommended over configuration. | `map` | `{}` | no |
| <a name="input_create_ns"></a> [create\_ns](#input\_create\_ns) | Whether to automatically create namespace | `bool` | `true` | no |
| <a name="input_default_storage_class_name"></a> [default\_storage\_class\_name](#input\_default\_storage\_class\_name) | High-performance storage type name, used to automatically generate PVC Claims, default Alibaba Cloud parameters | `string` | `"alicloud-disk-efficiency"` | no |
| <a name="input_default_storage_size"></a> [default\_storage\_size](#input\_default\_storage\_size) | High-performance storage volume size, the default Alibaba Cloud minimum is 20Gi | `string` | `"20Gi"` | no |
| <a name="input_has_filebeat"></a> [has\_filebeat](#input\_has\_filebeat) | n/a | `bool` | `false` | no |
| <a name="input_has_minio"></a> [has\_minio](#input\_has\_minio) | n/a | `bool` | `false` | no |
| <a name="input_has_mysql"></a> [has\_mysql](#input\_has\_mysql) | n/a | `bool` | `true` | no |
| <a name="input_has_rabbitmq"></a> [has\_rabbitmq](#input\_has\_rabbitmq) | n/a | `bool` | `false` | no |
| <a name="input_has_redis"></a> [has\_redis](#input\_has\_redis) | n/a | `bool` | `false` | no |
| <a name="input_minio_default_password"></a> [minio\_default\_password](#input\_minio\_default\_password) | n/a | `string` | `"73VyYWygp7VakhRC6hTf"` | no |
| <a name="input_minio_helm_override"></a> [minio\_helm\_override](#input\_minio\_helm\_override) | n/a | <pre>object({<br/>    version = optional(string, null)<br/>    values  = optional(list(any), [])<br/>  })</pre> | `{}` | no |
| <a name="input_minio_resources"></a> [minio\_resources](#input\_minio\_resources) | resource configuration | `map` | <pre>{<br/>  "limits": {},<br/>  "requests": {}<br/>}</pre> | no |
| <a name="input_minio_storage_class"></a> [minio\_storage\_class](#input\_minio\_storage\_class) | n/a | `string` | `""` | no |
| <a name="input_mysql_default_root_password"></a> [mysql\_default\_root\_password](#input\_mysql\_default\_root\_password) | n/a | `string` | `"6sg8vgDFcwWXP386EiZB"` | no |
| <a name="input_mysql_helm_override"></a> [mysql\_helm\_override](#input\_mysql\_helm\_override) | n/a | <pre>object({<br/>    version = optional(string, null)<br/>    values  = optional(list(any), [])<br/>  })</pre> | `{}` | no |
| <a name="input_mysql_init_database"></a> [mysql\_init\_database](#input\_mysql\_init\_database) | n/a | `string` | `"apitable"` | no |
| <a name="input_mysql_init_disk_size"></a> [mysql\_init\_disk\_size](#input\_mysql\_init\_disk\_size) | n/a | `string` | `"20Gi"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Note that the namespace is usually created during the process of creating the cloud storage PVC, and the namespace is not created here, only referenced | `string` | `"apitable-datacenter"` | no |
| <a name="input_rabbitmq_default_password"></a> [rabbitmq\_default\_password](#input\_rabbitmq\_default\_password) | n/a | `string` | `"7r4HVvsrwP4kQjAgj8Jj"` | no |
| <a name="input_rabbitmq_default_user"></a> [rabbitmq\_default\_user](#input\_rabbitmq\_default\_user) | n/a | `string` | `"user"` | no |
| <a name="input_rabbitmq_helm_override"></a> [rabbitmq\_helm\_override](#input\_rabbitmq\_helm\_override) | n/a | <pre>object({<br/>    version = optional(string, null)<br/>    values  = optional(list(any), [])<br/>  })</pre> | `{}` | no |
| <a name="input_rabbitmq_resources"></a> [rabbitmq\_resources](#input\_rabbitmq\_resources) | resource limits | `map` | <pre>{<br/>  "limits": {},<br/>  "requests": {}<br/>}</pre> | no |
| <a name="input_rabbitmq_storage_class"></a> [rabbitmq\_storage\_class](#input\_rabbitmq\_storage\_class) | n/a | `string` | `""` | no |
| <a name="input_redis_default_password"></a> [redis\_default\_password](#input\_redis\_default\_password) | n/a | `string` | `"UHWCWiuUMVyupqmW4cXV"` | no |
| <a name="input_redis_disk_size"></a> [redis\_disk\_size](#input\_redis\_disk\_size) | n/a | `string` | `"20Gi"` | no |
| <a name="input_redis_helm_override"></a> [redis\_helm\_override](#input\_redis\_helm\_override) | n/a | <pre>object({<br/>    version = optional(string, null)<br/>    values  = optional(list(any), [])<br/>  })</pre> | `{}` | no |
| <a name="input_redis_storage_class"></a> [redis\_storage\_class](#input\_redis\_storage\_class) | n/a | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
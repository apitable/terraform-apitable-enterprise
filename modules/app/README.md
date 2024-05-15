<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.16.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.backend_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.databus_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.document_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.filebeat_config_in](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.fusion_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.imageproxy_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.nest_rest_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.openresty_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.room_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.scheduler_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.socket_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.web_server_env](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_deployment.backend_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.databus_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.document_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.fusion_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.imageproxy_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.job_admin_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.nest_rest_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.openresty](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.room_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.scheduler_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.socket_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_deployment.web_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_horizontal_pod_autoscaler.databus_server_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/horizontal_pod_autoscaler) | resource |
| [kubernetes_horizontal_pod_autoscaler.document_server_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/horizontal_pod_autoscaler) | resource |
| [kubernetes_horizontal_pod_autoscaler.fusion_server_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/horizontal_pod_autoscaler) | resource |
| [kubernetes_horizontal_pod_autoscaler.nest_rest_server_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/horizontal_pod_autoscaler) | resource |
| [kubernetes_horizontal_pod_autoscaler.room_server_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/horizontal_pod_autoscaler) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.openresty-extend-ssl-certs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.openresty-ssl-certs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.backend_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.databus_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.document_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.fusion_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.imageproxy_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.job_admin_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.nest_rest_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.openresty_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.room_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.scheduler_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.socket_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.web_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_affinity"></a> [affinity](#input\_affinity) | n/a | `any` | `[]` | no |
| <a name="input_ai_server_sc"></a> [ai\_server\_sc](#input\_ai\_server\_sc) | ai\_server storage class | `map` | <pre>{<br>  "size": "10Pi",<br>  "volume_attributes": {<br>    "subPath": "ai_server"<br>  }<br>}</pre> | no |
| <a name="input_backend_server_depends_on"></a> [backend\_server\_depends\_on](#input\_backend\_server\_depends\_on) | n/a | `string` | `""` | no |
| <a name="input_create_ns"></a> [create\_ns](#input\_create\_ns) | Whether to automatically create namespace | `bool` | `true` | no |
| <a name="input_default_server_host"></a> [default\_server\_host](#input\_default\_server\_host) | Default route processing service | `string` | `"http://web-server"` | no |
| <a name="input_default_server_host_override_proxy_host"></a> [default\_server\_host\_override\_proxy\_host](#input\_default\_server\_host\_override\_proxy\_host) | n/a | `string` | `""` | no |
| <a name="input_developers_redirect_url"></a> [developers\_redirect\_url](#input\_developers\_redirect\_url) | n/a | `string` | `""` | no |
| <a name="input_disallow_robots"></a> [disallow\_robots](#input\_disallow\_robots) | Whether to disable crawlers | `bool` | `true` | no |
| <a name="input_docker_edition"></a> [docker\_edition](#input\_docker\_edition) | # Deprecate | `string` | `"vika"` | no |
| <a name="input_enable_ssl"></a> [enable\_ssl](#input\_enable\_ssl) | Whether to enable ssl | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | environment variable | `map(any)` | `{}` | no |
| <a name="input_envs"></a> [envs](#input\_envs) | Environment variables, submodules replace .env | `map` | `{}` | no |
| <a name="input_extend_tls_data"></a> [extend\_tls\_data](#input\_extend\_tls\_data) | Extended certificate crt and key contents | `map(any)` | <pre>{<br>  "tls_crt": "",<br>  "tls_domain": "",<br>  "tls_key": ""<br>}</pre> | no |
| <a name="input_has_ai_copilot"></a> [has\_ai\_copilot](#input\_has\_ai\_copilot) | Whether to deploy AI Copilot chroma db | `bool` | `false` | no |
| <a name="input_has_ai_server"></a> [has\_ai\_server](#input\_has\_ai\_server) | Whether to deploy AI server？ | `bool` | `false` | no |
| <a name="input_has_auto_reloaded_config_map"></a> [has\_auto\_reloaded\_config\_map](#input\_has\_auto\_reloaded\_config\_map) | Modify the configMap whether to automatically restart pods？ | `bool` | `false` | no |
| <a name="input_has_backend_server"></a> [has\_backend\_server](#input\_has\_backend\_server) | Whether to deploy Java-Api service？ | `bool` | `true` | no |
| <a name="input_has_bill_job_executor"></a> [has\_bill\_job\_executor](#input\_has\_bill\_job\_executor) | Whether to deploy XXL-JOB-subscription task executor service？ | `bool` | `false` | no |
| <a name="input_has_cron_job"></a> [has\_cron\_job](#input\_has\_cron\_job) | Whether it has a timed task job？ | `bool` | `true` | no |
| <a name="input_has_databus_server"></a> [has\_databus\_server](#input\_has\_databus\_server) | Deploy the databus-server？ | `bool` | `true` | no |
| <a name="input_has_dingtalk_server"></a> [has\_dingtalk\_server](#input\_has\_dingtalk\_server) | Whether to deploy DingTalk application integration service？ | `bool` | `false` | no |
| <a name="input_has_document_server"></a> [has\_document\_server](#input\_has\_document\_server) | Whether to deploy the Node-Nest.js-Document-Server service？ | `bool` | `false` | no |
| <a name="input_has_extend_tls"></a> [has\_extend\_tls](#input\_has\_extend\_tls) | Whether to support extended certificate | `bool` | `false` | no |
| <a name="input_has_fusion_server"></a> [has\_fusion\_server](#input\_has\_fusion\_server) | Whether to deploy the Node-Nest.js-Fusion-Api-Server service？ | `bool` | `true` | no |
| <a name="input_has_imageproxy_server"></a> [has\_imageproxy\_server](#input\_has\_imageproxy\_server) | Whether to deploy the Go image clipping service？ | `bool` | `false` | no |
| <a name="input_has_job_admin_server"></a> [has\_job\_admin\_server](#input\_has\_job\_admin\_server) | Whether to deploy XXL-JOB-Admin service？ | `bool` | `false` | no |
| <a name="input_has_load_balancer"></a> [has\_load\_balancer](#input\_has\_load\_balancer) | Does it come with Load Balancer? OpenResty exposes IP if any | `bool` | `false` | no |
| <a name="input_has_migration_server"></a> [has\_migration\_server](#input\_has\_migration\_server) | Whether to deploy Java-Data Migration Service？ | `bool` | `false` | no |
| <a name="input_has_nest_rest_server"></a> [has\_nest\_rest\_server](#input\_has\_nest\_rest\_server) | /dataPack API only, would be removed after publishing Galaxy version | `bool` | `false` | no |
| <a name="input_has_openresty"></a> [has\_openresty](#input\_has\_openresty) | Does it come with an openresty gateway? With public IP and load balancing | `bool` | `true` | no |
| <a name="input_has_openresty_ofelia_job"></a> [has\_openresty\_ofelia\_job](#input\_has\_openresty\_ofelia\_job) | whether to bring a lightweight OfeliaJob Container？ | `bool` | `false` | no |
| <a name="input_has_room_server"></a> [has\_room\_server](#input\_has\_room\_server) | Whether to deploy the Node-Nest.js-Room-Server service？ | `bool` | `true` | no |
| <a name="input_has_scheduler_server"></a> [has\_scheduler\_server](#input\_has\_scheduler\_server) | Whether to deploy the Node-Nest.js-Scheduler-Server service？ | `bool` | `true` | no |
| <a name="input_has_sensors_filebeat"></a> [has\_sensors\_filebeat](#input\_has\_sensors\_filebeat) | Whether to enable Sensors data collection | `bool` | `true` | no |
| <a name="input_has_socket_server"></a> [has\_socket\_server](#input\_has\_socket\_server) | Whether to deploy the Node-Nest.js-Socket-Server service？ | `bool` | `true` | no |
| <a name="input_has_space_job_executor"></a> [has\_space\_job\_executor](#input\_has\_space\_job\_executor) | Whether to deploy XXL-JO-workbench task executor service？ | `bool` | `false` | no |
| <a name="input_has_web_server"></a> [has\_web\_server](#input\_has\_web\_server) | Whether to deploy Web-Server (front-end template) service？ | `bool` | `true` | no |
| <a name="input_image_namespace"></a> [image\_namespace](#input\_image\_namespace) | What namespace container image to use when initializing | `string` | `"vikadata/vika"` | no |
| <a name="input_image_namespaces"></a> [image\_namespaces](#input\_image\_namespaces) | During initialization, you can freely control different container services, which namespaces are used respectively, and if any, overwrite image\_namespace. It is recommended that convention is better than configuration, and corresponding branches should be made in each project | `map(any)` | `{}` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | n/a | `string` | `"IfNotPresent"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | What version of the container image tag to use when initializing | `string` | `"latest-alpha"` | no |
| <a name="input_image_tags"></a> [image\_tags](#input\_image\_tags) | During initialization, you can freely control different container services, which tags are used respectively, and if any, overwrite image\_tag. It is recommended that convention is better than configuration. Make corresponding branches in each project, and use the last image\_tag variable for global unification instead of configuring here. In addition, it should be noted that the variables here are all underscored, such as the container service backend-server, the variables here correspond to backend\_server, and match the terraform variable naming practice | `map(any)` | `{}` | no |
| <a name="input_is_wait"></a> [is\_wait](#input\_is\_wait) | n/a | `bool` | `true` | no |
| <a name="input_job_admin_server_host"></a> [job\_admin\_server\_host](#input\_job\_admin\_server\_host) | n/a | `string` | `"job-admin-server"` | no |
| <a name="input_lbs_amap_secret"></a> [lbs\_amap\_secret](#input\_lbs\_amap\_secret) | Gaode map reverse proxy security key | `string` | `""` | no |
| <a name="input_minio_host"></a> [minio\_host](#input\_minio\_host) | Object storage service address | `string` | `"http://minio.apitable-datacenter:9090"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Shared namespace for applications | `string` | `"apitable-app"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | Node node label selector | `map` | `{}` | no |
| <a name="input_openresty_annotations"></a> [openresty\_annotations](#input\_openresty\_annotations) | openresty annotation, used to control load balancing specifications, slb.s1.small(5k), slb.s3.small(20w) / slb.s3.large(100w) | `map(any)` | <pre>{<br>  "service.beta.kubernetes.io/alibaba-cloud-loadbalancer-spec": "slb.s1.small"<br>}</pre> | no |
| <a name="input_openresty_extra_config"></a> [openresty\_extra\_config](#input\_openresty\_extra\_config) | nginx (openresty) external configuration file, which belongs to http internal level | `string` | `""` | no |
| <a name="input_openresty_index_block"></a> [openresty\_index\_block](#input\_openresty\_index\_block) | Homepage URI =/, support nginx, lua code block | `string` | `""` | no |
| <a name="input_openresty_server_block"></a> [openresty\_server\_block](#input\_openresty\_server\_block) | nginx (openresty) external configuration file, which belongs to the internal configuration of service | `string` | `""` | no |
| <a name="input_pricing_host"></a> [pricing\_host](#input\_pricing\_host) | pricing server | `string` | `"http://pricing.apitable-mkt"` | no |
| <a name="input_public_assets_bucket"></a> [public\_assets\_bucket](#input\_public\_assets\_bucket) | n/a | `string` | `"vk-assets-ltd"` | no |
| <a name="input_pv_csi"></a> [pv\_csi](#input\_pv\_csi) | csi storage namespace | <pre>object({<br>    namespace = optional(string, "vika-opsbase")<br>    driver    = string,<br>    fs_type   = string,<br>    node_publish_secret_ref = optional(string, "")<br>    storage_class_name      = optional(string, "")<br>    mount_options           = optional(list(any), [])<br>  })</pre> | <pre>{<br>  "driver": "csi.juicefs.com",<br>  "fs_type": "juicefs",<br>  "namespace": "vika-opsbase",<br>  "node_publish_secret_ref": "juicefs-sc-secret"<br>}</pre> | no |
| <a name="input_registry"></a> [registry](#input\_registry) | The dockerHub, the default is ghcr.io of github, the Vika accelerator is ghcr.vikadata.com, and the private warehouse is docker.vika.ltd | `string` | `"ghcr.io"` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | How many resources are used for different services? Including copy, CPU, and memory, the unit is MB. limit is the modified value × 2, and each environment has the default value of the minimum unit to start | `any` | `{}` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | default domain name | `string` | `"vika.ltd"` | no |
| <a name="input_tls_crt"></a> [tls\_crt](#input\_tls\_crt) | tls cert body | `string` | `""` | no |
| <a name="input_tls_key"></a> [tls\_key](#input\_tls\_key) | tls key body | `string` | `""` | no |
| <a name="input_tls_name"></a> [tls\_name](#input\_tls\_name) | tls cert name | `string` | `""` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | n/a | `any` | `[]` | no |
| <a name="input_worker_processes"></a> [worker\_processes](#input\_worker\_processes) | nginx(openresty) worker\_processes CPU core number, the corresponding CPU core number in the old version k8s | `string` | `"auto"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_ip"></a> [ingress\_ip](#output\_ingress\_ip) | Output ingress ip |
| <a name="output_ingress_ip_alternative"></a> [ingress\_ip\_alternative](#output\_ingress\_ip\_alternative) | n/a |
<!-- END_TF_DOCS -->
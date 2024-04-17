variable "namespace" {
  type        = string
  default     = "apitable-app"
  description = "Shared namespace for applications"
}

variable "create_ns" {
  default     = true
  type        = bool
  description = "Whether to automatically create namespace"
}

variable "has_load_balancer" {
  description = "Does it come with Load Balancer? OpenResty exposes IP if any"
  type        = bool
  default     = false
}


variable "has_cron_job" {
  description = "Whether it has a timed task job？"
  type        = bool
  default     = true
}

variable "has_openresty" {
  description = "Does it come with an openresty gateway? With public IP and load balancing"
  type        = bool
  default     = true
}

variable "has_openresty_ofelia_job" {
  description = "whether to bring a lightweight OfeliaJob Container？"
  type        = bool
  default     = false
}

variable "has_backend_server" {
  description = "Whether to deploy Java-Api service？"
  type        = bool
  default     = true
}

variable "has_sensors_filebeat" {
  default     = true
  type        = bool
  description = "Whether to enable Sensors data collection"
}

variable "has_job_admin_server" {
  description = "Whether to deploy XXL-JOB-Admin service？"
  type        = bool
  default     = false
}

variable "has_space_job_executor" {
  description = "Whether to deploy XXL-JO-workbench task executor service？"
  type        = bool
  default     = false
}

variable "has_bill_job_executor" {
  description = "Whether to deploy XXL-JOB-subscription task executor service？"
  type        = bool
  default     = false
}

variable "has_room_server" {
  description = "Whether to deploy the Node-Nest.js-Room-Server service？"
  type        = bool
  default     = true
}

variable "has_nest_rest_server" {
  description = "/dataPack API only, would be removed after publishing Galaxy version"
  type        = bool
  default     = false
}

variable "has_fusion_server" {
  description = "Whether to deploy the Node-Nest.js-Fusion-Api-Server service？"
  type        = bool
  default     = true
}

variable "has_scheduler_server" {
  description = "Whether to deploy the Node-Nest.js-Scheduler-Server service？"
  type        = bool
  default     = true
}

variable "has_socket_server" {
  description = "Whether to deploy the Node-Nest.js-Socket-Server service？"
  type        = bool
  default     = true
}

variable "has_document_server" {
  description = "Whether to deploy the Node-Nest.js-Document-Server service？"
  type        = bool
  default     = false
}

variable "has_web_server" {
  description = "Whether to deploy Web-Server (front-end template) service？"
  type        = bool
  default     = true
}

variable "has_migration_server" {
  description = "Whether to deploy Java-Data Migration Service？"
  type        = bool
  default     = false
}

variable "has_imageproxy_server" {
  description = "Whether to deploy the Go image clipping service？"
  type        = bool
  default     = false
}

variable "has_dingtalk_server" {
  description = "Whether to deploy DingTalk application integration service？"
  type        = bool
  default     = false
}

variable "has_ai_server" {
  description = "Whether to deploy AI server？"
  type        = bool
  default     = false
}

variable "has_ai_copilot" {
  description = "Whether to deploy AI Copilot chroma db"
  type        = bool
  default     = false
}

variable "has_databus_server" {
  description = "Deploy the databus-server？"
  type        = bool
  default     = true
}

variable "has_auto_reloaded_config_map" {
  description = "Modify the configMap whether to automatically restart pods？"
  type        = bool
  default     = false
}

variable "registry" {
  description = "The dockerHub, the default is ghcr.io of github, the Vika accelerator is ghcr.vikadata.com, and the private warehouse is docker.vika.ltd"
  type        = string
  default     = "ghcr.io"
}

variable "image_tag" {
  description = "What version of the container image tag to use when initializing"
  type        = string
  default     = "latest-alpha"
}

variable "image_tags" {
  description = "During initialization, you can freely control different container services, which tags are used respectively, and if any, overwrite image_tag. It is recommended that convention is better than configuration. Make corresponding branches in each project, and use the last image_tag variable for global unification instead of configuring here. In addition, it should be noted that the variables here are all underscored, such as the container service backend-server, the variables here correspond to backend_server, and match the terraform variable naming practice"
  type        = map(any)
  default     = {}
}

variable "image_namespace" {
  description = "What namespace container image to use when initializing"
  type        = string
  default     = "vikadata/vika"
}

variable "image_namespaces" {
  description = "During initialization, you can freely control different container services, which namespaces are used respectively, and if any, overwrite image_namespace. It is recommended that convention is better than configuration, and corresponding branches should be made in each project"
  type        = map(any)
  default     = {}
}

variable "env" {
  description = "environment variable"
  type        = map(any)
  default     = {}
}

variable "envs" {
  description = "Environment variables, submodules replace .env"
  #type        = map(any)
  default = {
  }
}

variable "resources" {
  description = "How many resources are used for different services? Including copy, CPU, and memory, the unit is MB. limit is the modified value × 2, and each environment has the default value of the minimum unit to start"
  type        = any
  default = {
  }
}

variable "image_pull_policy" {
  type    = string
  default = "IfNotPresent"
}

variable "is_wait" {
  type    = bool
  default = true
}

variable "public_assets_bucket" {
  type    = string
  default = "vk-assets-ltd"
}

variable "default_server_host_override_proxy_host" {
  type    = string
  default = ""
}

## Deprecate
variable "docker_edition" {
  type    = string
  default = "vika"
}

variable "node_selector" {
  default = {
  }
  description = "Node node label selector"
}

variable "ai_server_sc" {
  default = {
    size = "10Pi"
    volume_attributes = {
      subPath = "ai_server"
    }
  }
  description = "ai_server storage class"
}

variable "pv_csi" {
  type = object({
    namespace = optional(string, "vika-opsbase")
    driver    = string,
    fs_type   = string,
    node_publish_secret_ref = optional(string, "")
    storage_class_name      = optional(string, "")
  })
  default = {
    namespace               = "vika-opsbase"
    driver                  = "csi.juicefs.com"
    fs_type                 = "juicefs"
    node_publish_secret_ref = "juicefs-sc-secret"
  }
  description = "csi storage namespace"
}

variable "affinity" {
  type    = any
  default = []
}

variable "tolerations" {
  type    = any
  default = []
}

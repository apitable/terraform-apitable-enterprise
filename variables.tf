variable "namespace" {
  default     = "apitable-app"
  description = "Apitable app namespace"
}

variable "data_namespace" {
  default     = "apitable-datacenter"
  description = "Apitable datacenter namespace"
}

variable "create_ns" {
  default     = true
  type        = bool
  description = "Whether to automatically create namespace"
}


variable "env" {
  default = {
  }
  description = "Golbal Environment variables"
}


variable "envs" {
  default = {
    backend_server = {
      "BILLING_SELFHOST_ENABLED" = true
      "SELFHOST_EXPIRED_AT"      = "2024-11-01"
      "SKIP_REGISTER_VALIDATE"   = true
      "AFS_ENABLED"              = false
    }
    room_server = {

    }
    web_server = {

    }
    fusion_server = {

    }
  }
  description = "Environment variables, submodules replace .env"
}

variable "node_selector" {
  default     = {}
  description = "Node node label selector"
}

variable "has_datacenter" {
  default     = false
  description = "Whether to automatically create datacenter"
}

variable "has_mysql" {
  type        = bool
  default     = true
  description = "Whether to automatically create Mysql."
}

variable "has_redis" {
  type        = bool
  default     = true
  description = "Whether to automatically create Redis."
}

variable "has_minio" {
  type        = bool
  default     = true
  description = "Whether to automatically create Minio."
}

variable "has_rabbitmq" {
  type        = bool
  default     = true
  description = "Whether to automatically create RabbitMQ."
}

variable "regcred" {
  default = {
    registry_server = "ghcr.io"
    username        = ""
    password        = ""
  }
  description = "regcred info"
}

variable "image_tag" {
  default     = "latest"
  description = "During initialization, you can freely control different container services, which tags are used respectively, and if any, overwrite image_tag. It is recommended that convention is better than configuration. Make corresponding branches in each project, and use the last image_tag variable for global unification instead of configuring here. In addition, it should be noted that the variables here are all underscored, such as the container service backend-server, the variables here correspond to backend_server, and match the terraform variable naming practice"
}

variable "image_tags" {
  default = {
    web_server     = "latest-op"
    backend_server = "latest"
  }
  description = "What version of the container image tag to use when initializing"
}

variable "image_namespaces" {
  default = {
    init_settings  = "vikadata/apitable-ee"
    init_appdata   = "vikadata/apitable-ce"
    backend_server = "vikadata/apitable"
  }
}

variable "image_namespace" {
  default     = "vikadata/vika"
  description = "Universal Image Namespace"
}

variable "has_load_balancer" {
  default     = false
  description = "Does it come with Load Balancer? OpenResty exposes IP if any"
}

variable "resource" {
  default     = {}
  description = "How many resources are used for different services? Including copy, CPU, and memory, the unit is MB. limit is the modified value × 2, and each environment has the default value of the minimum unit to start"
}

variable "chart_repository" {
  default     = "../../charts/modules"
  description = "Default helm warehouse address , eg: https://charts.bitnami.com/bitnami "
}

variable "chart_repositorys" {
  default     = {}
  description = "When initializing the chart, you can freely control different container services, which repository is used respectively, and if there is one, override the repository. Convention is recommended over configuration."
}


variable "default_storage_size" {
  description = "High-performance storage volume size, the default Alibaba Cloud minimum is 20Gi"
  type        = string
  default     = "20Gi"
}

variable "default_storage_class_name" {
  description = "High-performance storage type name, used to automatically generate PVC Claims, default Alibaba Cloud parameters"
  type        = string
  default     = "alicloud-disk-efficiency"
}

variable "enable_ssl" {
  default     = false
  description = "Whether to enable ssl"
}

variable "server_name" {
  default     = ""
  description = "tls cert name"
}

variable "tls_crt" {
  default     = ""
  description = "tls cert body"
}

variable "tls_key" {
  default     = ""
  description = "tls key body"
}

variable "init_check_image" {
  default = "subfuzion/netcat:latest"
  description = "init-check image"
}
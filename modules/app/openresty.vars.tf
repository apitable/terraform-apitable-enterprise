variable "job_admin_server_host" {
  type    = string
  default = "job-admin-server"
}


variable "disallow_robots" {
  type        = bool
  default     = true
  description = "Whether to disable crawlers"
}

variable "default_server_host" {
  type        = string
  default     = "http://web-server"
  description = "Default route processing service"
}

variable "lbs_amap_secret" {
  type        = string
  default     = ""
  description = "Gaode map reverse proxy security key"
}

variable "minio_host" {
  type        = string
  default     = "http://minio.apitable-datacenter:9090"
  description = "Object storage service address"
}

variable "server_name" {
  type        = string
  default     = "vika.ltd"
  description = "default domain name"
}

variable "enable_ssl" {
  type        = bool
  default     = false
  description = "Whether to enable ssl"
}

variable "tls_name" {
  type        = string
  default     = ""
  description = "tls cert name"
}

variable "tls_crt" {
  type        = string
  default     = ""
  description = "tls cert body"
}

variable "tls_key" {
  type        = string
  default     = ""
  description = "tls key body"
}



variable "openresty_annotations" {
  type        = map(any)
  description = "openresty annotation, used to control load balancing specifications, slb.s1.small(5k), slb.s3.small(20w) / slb.s3.large(100w)"
  default = {
    "service.beta.kubernetes.io/alibaba-cloud-loadbalancer-spec" = "slb.s1.small"
  }
}

variable "openresty_extra_config" {
  type        = string
  default     = ""
  description = "nginx (openresty) external configuration file, which belongs to http internal level"
}

variable "openresty_server_block" {
  type        = string
  default     = ""
  description = "nginx (openresty) external configuration file, which belongs to the internal configuration of service"
}

variable "worker_processes" {
  default     = "auto"
  description = "nginx(openresty) worker_processes CPU core number, the corresponding CPU core number in the old version k8s"
}


variable "pricing_host" {
  type        = string
  default     = "http://pricing.apitable-mkt"
  description = "pricing server"
}

variable "openresty_index_block" {
  type        = string
  default     = ""
  description = "Homepage URI =/, support nginx, lua code block"
}

variable "developers_redirect_url" {
  type    = string
  default = ""
}


variable "has_extend_tls" {
  description = "Whether to support extended certificate"
  type        = bool
  default     = false
}

variable "extend_tls_data" {
  description = "Extended certificate crt and key contents"
  type        = map(any)
  default = {
    tls_crt     = ""
    tls_key     = ""
    tls_domain  = ""
  }
}
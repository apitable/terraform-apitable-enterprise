variable "namespace" {
  description = "Note that the namespace is usually created during the process of creating the cloud storage PVC, and the namespace is not created here, only referenced"
  type        = string
  default     = "apitable-datacenter"
}

variable "has_filebeat" {
  type    = bool
  default = false
}

variable "has_redis" {
  type    = bool
  default = false
}


variable "default_storage_class_name" {
  description = "High-performance storage type name, used to automatically generate PVC Claims, default Alibaba Cloud parameters"
  type        = string
  default     = "alicloud-disk-efficiency"
}

variable "default_storage_size" {
  description = "High-performance storage volume size, the default Alibaba Cloud minimum is 20Gi"
  type        = string
  default     = "20Gi"
}

variable "create_ns" {
  default     = true
  type        = bool
  description = "Whether to automatically create namespace"
}

variable "chart_repository" {
  default     = "https://charts.bitnami.com/bitnami"
  description = "Default helm warehouse address"
}

variable "chart_repositorys" {
  default     = {}
  description = "When initializing the chart, you can freely control different container services, which repository is used respectively, and if there is one, override the repository. Convention is recommended over configuration."
}

variable "chart_registry" {
  default     = "docker.io"
  description = "Default chart-registry address"
}

variable "chart_registrys" {
  default     = {}
  description = "During initialization, you can freely control different container services, which registry to use, and if any, override the registry. Convention is recommended over configuration."
}

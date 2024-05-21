
variable "redis_default_password" {
  type    = string
  default = "UHWCWiuUMVyupqmW4cXV"
}

variable "redis_disk_size" {
  type    = string
  default = "20Gi"
}

variable "redis_storage_class" {
  type    = string
  default = ""
}

variable "redis_helm_override" {
  default = {}
  type = object({
    version = optional(string, null)
    values  = optional(list(any), [])
  })
}

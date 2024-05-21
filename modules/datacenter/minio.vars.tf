variable "minio_default_password" {
  type    = string
  default = "73VyYWygp7VakhRC6hTf"
}

variable "has_minio" {
  type    = bool
  default = false
}

variable "minio_resources" {
  default = {
    limits = {
    }
    requests = {
    }
  }
  description = "resource configuration"
}

variable "minio_storage_class" {
  type    = string
  default = ""
}

variable "minio_helm_override" {
  default = {}
  type = object({
    version = optional(string, null)
    values  = optional(list(any), [])
  })
}

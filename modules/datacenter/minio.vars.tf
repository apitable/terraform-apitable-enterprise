
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
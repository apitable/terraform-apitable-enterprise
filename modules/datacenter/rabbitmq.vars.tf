variable "rabbitmq_default_password" {
  type    = string
  default = "7r4HVvsrwP4kQjAgj8Jj"
}
variable "rabbitmq_default_user" {
  type    = string
  default = "user"
}
variable "has_rabbitmq" {
  type    = bool
  default = false
}

variable "rabbitmq_resources" {
  default = {
    limits = {
    }
    requests = {
    }
  }
  description = "resource limits"
}
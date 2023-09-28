
module "apitable-enterprise" {

  source = "../../"

  namespace      = "apitable-enterprise"
  data_namespace = "apitable-datacenter"
  has_datacenter = true
  create_ns      = true

  // Environmental variables, such as databases, storage, etc.
  env = {
    "PARAM1" = "xx1"
    "PARAM2" = "xx2"
  }

  default_storage_class_name = "<your-storage-class-name>"

  regcred = {
    registry_server = "<your-registry-server>"
    username        = "<your-username>"
    password        = "<your-password>"
  }

}
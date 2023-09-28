terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
      #configuration_aliases = ["local"]
    }
    helm = {
      source = "hashicorp/helm"
      # Fix helm resource repeat.
      version = "2.9.0"
      #configuration_aliases = ["local"]
    }
  }
}

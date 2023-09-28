terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
    helm = {
      source = "hashicorp/helm"
      # Fix helm resource repeat.
      version = "2.9.0"
    }
  }
}

provider "kubernetes" {
  config_path = "${path.module}/config-k8s/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/config-k8s/kubeconfig"

  }
}
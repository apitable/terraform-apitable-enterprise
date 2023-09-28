terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8.0"
    }
  }
}

resource "kubernetes_namespace" "this" {
  count = var.create_ns ? 1 : 0
  metadata {
    name = var.namespace
  }
}

data "kubernetes_namespace" "this" {
  count = var.create_ns ? 0 : 1
  metadata {
    name = var.namespace
  }
}

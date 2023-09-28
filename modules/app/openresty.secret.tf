resource "kubernetes_secret" "openresty-ssl-certs" {
  depends_on = [kubernetes_namespace.this]
  metadata {
    name      = "openresty-ssl-certs"
    namespace = var.namespace
    annotations = {
      "domain"  = var.server_name
    }
  }

  data = {
    "tls.crt" = var.tls_crt
    "tls.key" = var.tls_key
  }

  type = "IngressTLS"
}

#extend certs for openresty
resource "kubernetes_secret" "openresty-extend-ssl-certs" {
  count = var.has_extend_tls ? 1 : 0
  depends_on = [kubernetes_namespace.this]
  metadata {
    name        = "openresty-extend-ssl-certs"
    namespace   = var.namespace
    annotations = {
      "domain"  = var.extend_tls_data.tls_domain
    }
  }


  data = {
    "tls.crt" = var.extend_tls_data.tls_crt
    "tls.key" = var.extend_tls_data.tls_key
  }

  type = "IngressTLS"
}


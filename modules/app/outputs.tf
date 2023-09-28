
#Output ingress ip
output "ingress_ip" {
  value = var.has_load_balancer ? kubernetes_service.openresty_server[0].status[0].load_balancer[0].ingress[0].ip : ""
}

output "ingress_ip_alternative" {
  value = var.has_load_balancer ? try(kubernetes_service.openresty_server[0].status[0].load_balancer[0].ingress[1].ip, "") : ""
}

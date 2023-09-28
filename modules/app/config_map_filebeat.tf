resource "kubernetes_config_map" "filebeat_config_in" {
  depends_on = [
    kubernetes_namespace.this
  ]
  metadata {
    name      = "filebeat-config-in"
    namespace = var.namespace

    labels = {
      sa-app  = "filebeat"
      feature = "sensors"
    }
  }

  data = {
    "filebeat.yml" = <<-EOT
     filebeat.inputs:
     - type: log
       #Read files starting with service_log in the /var/log/containers directory.
       paths:
         - /logs/sensors/backend-server*/service_log.*

     output.logstash:
       #Cluster Intranet Logstash.
       hosts: ["logstash.vika-datacenter.svc.cluster.local:5044"]
     EOT
  }
}

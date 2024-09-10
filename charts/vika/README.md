### Introduction
This chart bootstraps a replication cluster deployment on a cluster using the  package manager.

Vika charts can be used with for deployment and management of Helm Charts in clusters.

### Prerequisites
+ Kubernetes 1.23+
+ Helm 3.8.0+
+ PV provisioner support in the underlying infrastructure


### QuckStart
To install the chart with the release name `vika-release`:

```
helm install vika-release oci://REGISTRY_NAME/REPOSITORY_NAME/vika-helm-chart
```
Note: You need to substitute the placeholders REGISTRY_NAME and REPOSITORY_NAME with a reference to your Helm chart registry and repository. For example, in the case of vikadata, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=vikadata`.

These commands deploy vika on the Kubernetes cluster in the default configuration. The  section lists the parameters that can be configured during installation.

Tip: List all releases using helm list


To upgrade:

```
helm upgrade vika-release oci://REGISTRY_NAME/REPOSITORY_NAME/vika-helm-chart
```

To uninstall:
```
helm uninstall vika-release
```

## Parameters
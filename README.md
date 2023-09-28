# Apitable Enterprise modules

## Introduction
`APITable`  Terraform Modulesis a set of Terraform modules for managing and deploying APITable resources. These modules are designed to simplify the process of creating and configuring APITable resources, provide reusable code blocks, and help you quickly set up and manage your APITable environment.


## Module List
The following APITable Terraform modules are available:

* Apitable-app:
    * `web-server`: build supercharged, SEO-friendly, and extremely user-facing static website and web application by using NextJS
    * `backend-server`: handles HTTP requests about nodes, users, organizations, etc. Code under Java Spring Boot Framework
    * `room-server`: handles operations(OTJSON) of datasheets, communicates with Socket Server through gRPC, and also provides APIs for developers. Coding under TypeScript and NestJS framework.
        + `nest-server`: handles HTTP GET requests about datasheets, records, views, etc.
        + `socket-server`: establishes a long connection with clients through the WebSocket protocol, allowing for two-way communication and real-time collaboration, notifications, and other features.
    * `openresty`: Popular open source gateways.

* Apitable-datacenter:
    * `MySQL`: Mysql is a popular relational database management system, often used for back-end data storage of web applications. 
    * `Redis`: Redis is a fast in-memory data structure storage system commonly used for caching and message queues.
    * `RabbitMQ`: RabbitMQ is an open source message queuing software used for asynchronous communication between applications.
    * `Minio`: Minio is an open source object storage server that can be used to store and manage large amounts of data.

* Regcred: Acts on Docker registry, users download docker image authentication.

* Charts: Offline charts of the stable version, which includes core modules such as minio, mysql, rabbitmq and redis.




## Requiremnet
1. `kubconfig` certificate, which requires the following permissions
```
  - configmap:*
  - pv:*
  - pvc:*
  - service:*
  - deployment:*
  - ns: create, get, list, watch
  - events: create, get, list,delete, watch
  - secret: *
```

2. The cluster has installed the kubernetes-csi driver and obtained the `storageclass`.
3. Providers for Kubernetes and Helm, referring to the values in the examples.


## Usage
To use the APITable Terraform Modules, follow these steps:

1. Create a new directory in your Terraform project to store your APITable-related configuration files.
2. Create a `main.tf` file in that directory and reference the desired modules.
3. Configure the input variables for each module to meet your needs.
4. Run the `terraform init` command to initialize your Terraform environment.
5. Run the `terraform apply` command to create and configure your APITable resources.


## Example

Here's an example of using the APITable Terraform Modules to create an APITable application and database:

```hcl
module "apitable-enterprise" {
   source  = "apitable/enterprise/apitable"
   version = "1.0.0"

   namespace = "apitable-enterprise"

   // Environmental variables, such as databases, storage, etc.
   env = {
      "PARAM1" = "xx1"
      "PARAM2" = "xx2"
   }
  
   default_storage_class_name = "<your-storage-class-name>"

   regcred = {
     registry_server   = "<your-registry-server>"
     username          = "<your-username>"
     password          = "<your-password>"
   }
  
  #Optional, refer https://apitable.getoutline.com/s/82e078fc-1a8d-4616-b69d-fcdbb18ef715/doc/image-version-inventory-J9TZe7ym8I to replace the image version
  image_tags = {
    backend_server = "latest-alpha"
    room_server    = "latest-alpha"
    web_server     = "latest-alpha" 

    #And others ..
  } 
}
```

## FAQ
### Q1: How to get regcred information?

A: Submit the [form](https://vika.cn/share/shrdm5smaJ9XsxSzdTJVw/fom8jGSU4RqAw3vXNs) to request a trial.


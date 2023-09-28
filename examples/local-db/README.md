## This example creates an apitable from the built-in  `datacenter` and `app` modules

## Configration
1. Replace the kubeconfig certificate to `config-k8s/kubeconfig` with the appropriate one.
2. Replace `namespace`, `env`, `default_storage_class_name` and other configurations according to the annotation instructions
3. Replace all the `regcred` informations .

## Useage
To run this example you need to execute:
```
$ terraform init
$ terraform plan
$ terraform apply
```
Run `terraform destroy` when you don't need these resources.


### Instructions
```mermaid
graph TD;
  subgraph "APITable Infrastructure";
      Client -->|HTTP| gateway((Gateway));
 
  subgraph "k8s"      
    subgraph "Apitalbe-app (namespace)";
      gateway -->|HTTP| backend-server;
      gateway -->|Web Socket| socket-server;
      gateway -->|HTTP| web-server;
      gateway -->|HTTP| room-server;
      room-server --> backend-server;
      gateway --> |HTTP| imageproxy-server;

    end    
      
    subgraph "Apitable-db (namespace)";
      socket-server -->  |Web Socket| room-server;
      backend-server -->|Read/Write| mysql((MySQL));
      backend-server -->|Read/Write| redis((Redis));
      backend-server -->|Read/Write| S3((minio));
      room-server -->|Read/Write| mysql((MySQL));
      room-server -->|Read/Write| redis((Redis));
      room-server -->|Read/Write| mq((RabbitMQ));
      imageproxy-server -->|Read| S3((minio));
    end 
  end

  end
```

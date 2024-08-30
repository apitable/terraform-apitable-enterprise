
# Helm Charts 安装包



## Note
`@remove_tf_local`: When packaging ops-manager, delete this line of comment code

`@add_tf_local`: When packaging ops-manager, enable this line of annotation code


## 安装
1. 初始化配置 `values.yaml`
```
global:
    env:
    MYSQL_HOST: "vika-pxc-db-proxysql"
    MYSQL_PORT: "3306"
    MYSQL_DATABASE : "apitable"
    MYSQL_PASSWORD : "apitable@com"
    MYSQL_USERNAME : "root"
    DATABASE_TABLE_PREFIX: "apitable_"
    RABBITMQ_HOST : rabbitmq
    RABBITMQ_PASSWORD : 7r4HVvsrwP4kQjAgj8Jj
    RABBITMQ_PORT : "5672"
    RABBITMQ_USERNAME : user
    RABBITMQ_VHOST : /
    REDIS_DB: "4"
    REDIS_HOST: redis-master
    REDIS_PASSWORD: UHWCWiuUMVyupqmW4cXV
    REDIS_PORT : "6379"

imagePullSecrets: ["regcred"]

app:

```

helm 


### 1. quick start

### 2. 
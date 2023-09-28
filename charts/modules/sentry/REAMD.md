### sentry 安装方法
[参考文档](https://artifacthub.io/packages/helm/sentry/sentry)
[Usage with Terraform + AWS](https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller)

#### 准备
1. helm repo add sentry https://sentry-kubernetes.github.io/charts
2. eks alb 网络组件
```
# 安装 controller
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

helm repo add eks https://aws.github.io/eks-charts

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
--set clusterName=$CLUSTER \
--set serviceAccount.create=false \
--set region=$REGION \
--set vpcId=$VPCID \
--set serviceAccount.name=aws-load-balancer-controller \
--set image.repository=918309763551.dkr.ecr.cn-north-1.amazonaws.com.cn/amazon/aws-load-balancer-controller \
-n kube-system


helm --kubeconfig ~/.kube_eks/config install aws-load-balancer-controller eks/aws-load-balancer-controller \
--set clusterName=tf-sentry \
--set serviceAccount.create=false \
--set region=cn-northwest-1 \
--set image.repository=918309763551.dkr.ecr.cn-north-1.amazonaws.com.cn/amazon/aws-load-balancer-controller \
-n kube-system

```

#### 配置文件
values.yaml

#### 测试
helm install --dry-run --debug  sentry sentry/sentry  -f values.yaml -n sentry

#### 正式安装
helm install --debug  sentry sentry/sentry  -f values.yaml -n sentry

#### 更新配置
helm upgrade  --debug  sentry sentry/sentry  -f values.yaml -n sentry

#### 查看安装结果
kubectl get pods -n sentry


#### 手动创建客户(非必须)
```
登陆sentry-web的pod，用命令创建超级用户：
kubectl exec -it sentry-web-xxxx -n sentry -- bash
sentry createuser
```
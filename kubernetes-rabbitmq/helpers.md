# You will need to use metrics-server to collects metrics from your cluster

# Kubectl apply Manifests

1. kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

# Helm Installation

1. helm search repo bitnami/rabbitmq --versions

helm show values bitnami/rabbitmq

2. helm repo add bitnami https://charts.bitnami.com/bitnami --force-update

3. helm upgrade --install rabbitmq bitnami/rabbitmq \
  --set auth.username=admin \
  --set auth.password=#R00t \
  --set auth.erlangCookie=AQ5GuKmX1FZnQ2LeTbbpoBQgaB2E9qlz \
  --set metrics.enabled=true \
  --version 15.0.5 \
  --namespace rabbitmq \
  --create-namespace

# Helm Uninstallation

1. helm uninstall rabbitmq -n rabbitmq

2. kubectl delete ns rabbitmq

# Kubectl apply Output YAML

1. helm template rabbitmq bitnami/rabbitmq \
  --set auth.username=admin \
  --set auth.password=#R00t \
  --set auth.erlangCookie=AQ5GuKmX1FZnQ2LeTbbpoBQgaB2E9qlz \
  --set metrics.enabled=true \
  --version 15.0.5 \
  --namespace rabbitmq \
  --create-namespace \
  > ./rabbitmq-15.0.5.yaml

2. kubectl apply -f ./rabbitmq-15.0.5.yaml

# Forward ports

1. UI:
  - kubectl port-forward --namespace rabbitmq svc/my-rabbitmq 15672:15672

2. Broker:
  - kubectl port-forward --namespace rabbitmq svc/rabbitmq 5672:5672

3. Prometheus:
  - kubectl port-forward --namespace rabbitmq svc/rabbitmq 9419:9419

# Verify installation

1. kubectl get all -o wide -n rabbitmq-system

Persistent Storage:
  --set persistence.enabled=true \
  --set persistence.size=8Gi

username and password:
  --set auth.username=myuser \  
  --set auth.password=mypassword

TLS/SSL:
  --set auth.tls.enabled=true \
  --set auth.tls.existingSecret=my-tls-secret


High Availability:
  --set replicaCount=3

Monitoring:
  --set metrics.enabled=true

Scaling RabbitMQ Horizontally:
  --set replicaCount=3 \
  --set clustering.enabled=true \
  --set clustering.forceBoot=true

Load Balancing with Ingress:
  --set ingress.enabled=true \
  --set ingress.hostname=my-rabbitmq.example.com \
  --set ingress.tls=true \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx

# Managing Updates

With Helm, you can easily update your RabbitMQ installation by adjusting values and reapplying them. For example, to change resource limits or add a new plugin, you can update the Helm release:

  --set resources.requests.memory=512Mi \
  --set plugins="rabbitmq_management,rabbitmq_shovel,rabbitmq_federation"

# Credentials

Credentials:
    echo -e "Username      : admin"
    echo -e "Password      : $(kubectl get secret --namespace rabbitmq rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
    echo -e "ErLang Cookie : $(kubectl get secret --namespace rabbitmq rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)"

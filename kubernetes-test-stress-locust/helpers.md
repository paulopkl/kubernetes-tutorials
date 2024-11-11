# You will need to use metrics-server to collects metrics from your cluster

# Kubectl apply Manifests

1. kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

# Helm Installation

1. helm search repo bitnami/rabbitmq --versions

helm show values bitnami/rabbitmq

2. helm repo add deliveryhero https://charts.deliveryhero.io/ --force-update


3. helm upgrade --install my-locust deliveryhero/locust \
  --set master.auth.username=admin \
  --set master.auth.password=#R00t \
  --version 0.31.6 \
  --namespace default \
  --create-namespace

# Helm Uninstallation

1. helm uninstall my-locust -n default

2. kubectl delete ns default

# Kubectl apply Output YAML

1. helm template my-locust deliveryhero/locust \
  --set master.auth.username=admin \
  --set master.auth.password=#R00t \
  --version 0.31.6 \
  --namespace default \
  --create-namespace \
  > ./rabbitmq-0.31.6.yaml

2. kubectl apply -f ./rabbitmq-0.31.6.yaml

# Forward ports

1. UI:
  - kubectl --namespace default port-forward service/locust-giropops 5000:80

# watch logs

1. kubectl logs deploy/giropops-senhas

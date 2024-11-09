# You will need to use metrics-server to collects metrics from your cluster

# Kubectl apply Manifests

  # Including admission webhooks
  1. kubectl apply --server-side -f https://github.com/kedacore/keda/releases/download/v2.12.1/keda-2.12.1.yaml

  # Without admission webhooks (Simpliest)
  1. kubectl apply --server-side -f https://github.com/kedacore/keda/releases/download/v2.12.1/keda-2.12.1-core.yaml

# Helm Installation

1. helm search repo kedacore --version

2. helm repo add kedacore https://kedacore.github.io/charts --force-update

3. helm upgrade --install keda kedacore/keda \
  --version 2.15.2 \
  --namespace keda \
  --create-namespace

# Kubectl apply Output YAML

1. helm template keda kedacore/keda \
  --version 2.15.2 \
  --namespace keda \
  --create-namespace \
  > ./keda/keda-2.15.2.yaml

2. kubectl apply -f ./keda/keda-2.15.2.yaml

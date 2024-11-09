# You will need to use metrics-server to collects metrics from your cluster

# Kubectl apply Manifests

1. kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability.yaml

# Helm Installation

1. helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ --force-update

2. helm upgrade --install metrics-server metrics-server/metrics-server \
  --version 3.11.0 \
  --namespace kube-system \
  --set "args[0]=--kubelet-insecure-tls" \

# Kubectl apply Output YAML

1. helm template metrics-server metrics-server/metrics-server \
  --version 3.11.0 \
  --namespace kube-system \
  # --set prometheus.enabled=false \   # Example: disabling prometheus using a Helm parameter
  > ./metrics-server/metrics-server-3.11.0.yaml

2. kubectl apply -f ./metrics-server/metrics-server-3.11.0.yaml

# Verify Metrics-Server
1. kubectl top pods

2. kubectl proxy

3. kubectl get --raw https://127.0.0.1:8001/apis/metrics.k8s.io/v1beta1/namespaces/default/pods

curl "localhost:8080/api/cpu?index=50"

# Don't use replicas inside Deployment or StatefulSet if you are using GitOps approach, 'cause it will constantly set the pods quantity

# See that differents application may have different CPU usage

1. Keep it more minimal as possible

2. Pay attention in 4 signals:
  - Latency
  - Traffic
  - Errors
  - Saturation

# Never use HPA (Horizontal Pod Autoscaler) and VPA (Vertical Pod Autoscaler) in the same Deployment or StatefulSet 

# Don't use VPA for Stateless applications, just for Stateful applications (Use only for apps that cannot be scaled horizontally)



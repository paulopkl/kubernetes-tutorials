# Kubectl apply Manifests

1. kubectl create ns cert-manager

2. kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml

# Helm Installation

1. helm repo add jetstack https://charts.jetstack.io --force-update

2. helm install cert-manager jetstack/cert-manager \
  --set crds.enabled=true \
  --version v1.16.1 \
  --namespace cert-manager \
  --create-namespace

# Kubectl apply Output YAML

1. helm template cert-manager jetstack/cert-manager \
  --set crds.enabled=true \
  --version v1.16.1 \
  --namespace cert-manager \
  > ./cert-manager/cert-manager-1-16-1.yaml
# --set prometheus.enabled=false \  # Example: disabling prometheus using a Helm parameter

2. kubectl create ns cert-manager

3. kubectl apply -f ./cert-manager/cert-manager-1-16-1.yaml

# Validate

1. kubectl get clusterissuer -A
    1. kubectl describe clusterissuer letsencrypt-issuer -n default

2. kubectl get certificate -A
    1. kubectl describe certificate api-cert -n default

3. kubectl get secrets -A
    1. kubectl describe secret api-tls-secret -n default

# Possible problems

1. DNS must resolve to the Load Balancer (Public IP), if this wes remove, cert manager will try renew in loop

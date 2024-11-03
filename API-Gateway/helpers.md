1. Install the Gateway API resources 
kubectl kustomize "https://github.com/nginxinc/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v1.4.0" | kubectl apply -f -


2. Deploy the NGINX Gateway Fabric CRDs (Custom Resources Defitions)
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/crds.yaml


3. Deploy NGINX Gateway Fabric 
Deploys NGINX Gateway Fabric with NGINX OSS using a Service type of NodePort.
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/nodeport/deploy.yaml


# install nginx ingress controller repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Search Repo versions available
helm search repo ingress-nginx --versions

helm template ingress-nginx ingress-nginx \
--repo https://kubernetes.github.io/ingress-nginx \
--version 4.11.3 \
--namespace ingress-nginx > ./nginx-ingress-controller/ingress-nginx-1.11.3.yaml

kubectl create ns ingress-nginx

kubectl apply ./nginx-ingress-controller/ingress-nginx-1.11.3.yaml


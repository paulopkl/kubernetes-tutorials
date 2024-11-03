$ minikube start --nodes 3 --driver=docker

$ kubectl taint nodes minikube-m03 instance_type=gpu:NoSchedule

$ kubectl exec -i -t dnsutils -- nslookup nginx-2.nginx.default

$ kubectl port-forward <cadvisor-pod-name> 8080:8080

$ kubectl port-forward <node-exporter-pod-name> 9100:9100

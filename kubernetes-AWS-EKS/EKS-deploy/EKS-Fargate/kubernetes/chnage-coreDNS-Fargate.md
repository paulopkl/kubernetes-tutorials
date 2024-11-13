watch -n 1 kubectl get pods -n kube-system

--------------------

kubectl get events -w -n kube-system

--------------------

kubectl patch deployment coredns \
-n kube-system \
--type json \
-p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'

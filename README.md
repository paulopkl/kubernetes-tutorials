# [Create Local Cluster](https://github.com/paulopkl/kubernetes-tutorials/tree/main/Local-cluster)

1. Create a local cluster using Kind (1 control-plane and 2 workers):
    - Kind
    - Kubectl
    - port 8080 mapped to nodeport 31437
    - port 8081 mapped to nodeport 31438 

# Create AWS Kubernetes Cluster (EKS)

## Create a Standard Cluster

## Create a Complete Cluster

## Create a Fargate Cluster


# Kubernetes

## [Main features](https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-pod-lifecycle)

1. Pod Lifecycle has Features like: 
    - Deployment
    - PersistentVolumeClaim
    - HorizontalPodAutoscaler
    - StatefulSet
    - DaemonSet + (node-exporter, cadvisor)
    - CronJob
    - Job

## [All of Kubernetes Network](https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-network)

1. Different types of Service within Kubernetes in:
    - ClusterIP
    - LoadBalancer
    - NodePort

2. Exploring Ingress and TLS:
    - helm
    - Ingress (nginx-ingress-controller)
    - Cert-Manager

## [All of SSL/TLS using Cert-Manager](https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-cert-manager)

1. Exploring Cert-Manager and Certicate management:

## [All of API-Gateway](https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-api-gateway)

1. Exploring about API Gateway inside Kubernetes:

## All of Kubernetes Scale

1. [Metrics-server:]https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-autoscale/metrics-server
    - Helm
    - Install metrics-server

2. [Explore about HorizontalPodAutoscaler (HPA):](https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-autoscale/HPA)

2. [Explorte about VerticalPodAutoscaler (VPA):](https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-autoscale/VPA)

4. KEDA

## Using Karpenter within Kubernetes

1. [Explore the use of Karpenter:](https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-karpenter)

2. Tudo sobre EKS, Karpenter
    - https://github.com/clowdhaus/eks-reference-architecture/blob/main/karpenter-gpu/README.md

## Using RabbitMQ within Kubernetes

1. Explore the use of Karpenter: https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-rabbitmq

## Using Kubernetes On-Premises

1. [Explore the use of Kubernetes on Local Datacenters:](https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-on-premises)

## Using Kubernetes with Crossplane

1. [Explore the fact of creating Cloud resources using Kubernetes yaml files plus Crossplane:](https://github.com/paulopkl/kubernetes-tutorials/tree/main/kubernetes-crossplane)
    - Helm
    - Crossplane

# Tests

## API Stress Test

1. Test API by sending, requests: kubernetes-test-stress-locust
    - Helm
    - Locust
    - HPA
    - metrics-server

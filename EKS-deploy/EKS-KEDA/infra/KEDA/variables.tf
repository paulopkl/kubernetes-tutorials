
variable "region" {
    type = string
    default = "us-east-1"
    description = "AWS Region"
}

variable "cluster_name" {
    type = string
    default = "eks-demo"
    description = "Cluster Name"
}

variable "kubernetes_config_path" {
    type = string
    default = "~/.kube/config"
    description = "Kubernetes configuration Path"
}

variable "kubernetes_keda_namespace" {
    type = string
    default = "keda"
    description = "namespace where keda is installed"
}

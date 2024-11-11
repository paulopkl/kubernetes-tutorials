terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "2.23.0"
        }
        local = {
            source  = "hashicorp/local"
            version = "~> 2.4.0"
        }
        helm = {
            source  = "hashicorp/helm"
            version = "2.10.1"
        }
    }
}

provider "aws" {
    region = var.region
}

data "aws_eks_cluster" "eks_cluster" {
    name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
    name = var.cluster_name
}

# provider "kubernetes" {
#     # config_path = var.kubernetes_config_path
#     # config_context = ""

#     # exec {
#     #     api_version = "client.authentication.k8s.io/v1beta1"
#     #     args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
#     #     command     = "aws"
#     # }
# }

provider "kubernetes" {
    host = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "helm" {
    kubernetes {
        host = data.aws_eks_cluster.eks_cluster.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
        token = data.aws_eks_cluster_auth.eks_cluster_auth.token   
    }
}

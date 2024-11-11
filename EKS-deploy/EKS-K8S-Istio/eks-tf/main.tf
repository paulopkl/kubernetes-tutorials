terraform {
  required_version = ">= 1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.56"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.2"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.0"  # Specify the version you want to use
    }
  }

  # backend "s3" {
    
  # }
}

provider "aws" {
  region  = var.aws_region
  profile = "root"
}

#provider "helm" {
#  kubernetes {
#    config_path = "~/.kube/config"
#  }
#}

provider "helm" {

  kubernetes {
    config_path            = "~/.kube/config"
    host                   = aws_eks_cluster.demo.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.demo.certificate_authority[0].data)
    
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.demo.id]
      command     = "aws"
    }
  }
}

provider "null" {
  # No specific configuration required for the null provider
}

# data "aws_eks_cluster" "eks" {
#   depends_on = [aws_eks_cluster.demo]

#   name = "var.aws_eks_cluster_name
# }

# data "aws_eks_cluster_auth" "eks" {
#   depends_on = [aws_eks_cluster.demo]

#   name = var.aws_eks_cluster_name
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.eks.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.eks.token
#   }
# }

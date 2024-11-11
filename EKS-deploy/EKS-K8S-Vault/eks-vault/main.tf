terraform {
  required_version = ">= 1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.51.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.0"  # Specify the version you want to use
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

# data "aws_eks_cluster" "eks" {
#   depends_on = [aws_eks_cluster.eks]

#   name = "${var.env}-${var.eks_name}"
# }

data "aws_eks_cluster_auth" "eks" {
  depends_on = [aws_eks_cluster.eks]

  name = "${var.env}-${var.eks_name}"
}

provider "kubectl" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "null" {
  # No specific configuration required for the null provider
}

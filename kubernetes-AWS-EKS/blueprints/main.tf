module "networking" {
  source = "./network-module"

  aws_region     = "us-east-1"
  cluster_name   = "test-eks-k8s"
  vpc_cidr_block = "10.0.0.0/16"
}

module "EKS" {
  depends_on = [
    module.networking
  ]

  source = "./EKS-module"

  kubernetes_version = "1.31"
  cluster_name       = "test-eks-k8s"
  subnets_ids        = module.networking.subnet_ids
}

module "Addons" {
  depends_on = [
    module.EKS
  ]

  source = "./EKS-Addons"

  cluster_issuer_url = module.EKS.cluster_issuer_url
  thumbprint_list    = module.EKS.thumbprint_list
}

aws_region           = "us-west-2"
aws_eks_cluster_name = "demo"
eks_addons = [
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.29.1-eksbuild.1"
  }
]

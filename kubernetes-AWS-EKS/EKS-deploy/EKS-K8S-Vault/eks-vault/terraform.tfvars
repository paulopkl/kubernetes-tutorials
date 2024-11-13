aws_profile   = "root"
aws_region    = "us-east-1"
env           = "devcql"
region        = "us-east-1"
zone1         = "us-east-1a"
zone2         = "us-east-1b"
eks_name      = "key-vault"
eks_version   = "1.29"
namespace     = "default"
key_pair_name = "hashicorp_key_vault"
eks_addons = [
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.29.1-eksbuild.1"
  }
]

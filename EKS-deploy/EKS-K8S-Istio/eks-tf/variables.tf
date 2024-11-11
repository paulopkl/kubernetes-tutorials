variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
}

variable "aws_eks_cluster_name" {
  type        = string
  description = "AWS Region"
  default     = "demo"
}

variable "eks_addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.29.1-eksbuild.1"
    }
  ]
}

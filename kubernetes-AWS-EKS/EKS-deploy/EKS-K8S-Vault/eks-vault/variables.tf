variable "aws_profile" {
  type        = string
  description = "AWS Profile"
  default     = "root"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "env" {
  type    = string
  default = "devcql"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "zone1" {
  type    = string
  default = "us-west-2a"
}

variable "zone2" {
  type    = string
  default = "us-west-2b"
}

variable "eks_name" {
  type    = string
  default = "key-vault"
}

variable "eks_version" {
  type    = string
  default = "1.29"
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "key_pair_name" {
  type    = string
  default = "hashicorp_key_vault"
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

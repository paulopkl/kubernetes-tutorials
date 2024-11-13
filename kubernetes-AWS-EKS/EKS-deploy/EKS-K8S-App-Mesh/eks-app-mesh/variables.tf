variable "aws_profile" {
  type        = string
  description = "AWS Profile"
  default     = "root"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
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
  default = "cloudquicklabs"
}

variable "eks_version" {
  type    = string
  default = "1.29"
}

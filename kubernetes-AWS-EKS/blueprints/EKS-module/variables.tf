variable "cluster_name" {
  default = "demo"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "kubernetes_version" {
  default = "1.31"
}

variable "subnets_ids" {
  type = set(string)
}
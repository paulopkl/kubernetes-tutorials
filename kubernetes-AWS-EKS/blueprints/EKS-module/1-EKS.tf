resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-eks-iam-role"

  assume_role_policy = jsondecode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

### Kubernetes Cluster
resource "aws_eks_cluster" "cluster" {
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]

  name     = var.cluster_name
  version  = var.kubernetes_version # "1.31"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = var.subnets_ids
  }
}

output "cluster_issuer_url" {
  value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "thumbprint_list" {
  value = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
}
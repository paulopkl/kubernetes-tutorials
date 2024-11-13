resource "aws_iam_role" "service_a" {
  name = "${var.env}-${var.eks_name}-eks-server-svc"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn # EKS OIDC arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:server:server-sa" // "system:serviceaccount:[Namespace]:[Service Account]"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "service_a" {
  name = "AppMeshServiceAAccess"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Resource = "*"
        Effect   = "Allow"
        Action = [
          "appmesh:StreamAggregatedResources"
        ]
      },
      {
        Resource = "*"
        Effect   = "Allow"
        Action = [
          "acm:ExportCertificate",
          "acm-pca:GetCertificateAuthorityCertificate"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "service_a" {
  role       = aws_iam_role.service_a.name // "${var.env}-${var.eks_name}-eks-server-svc"
  policy_arn = aws_iam_policy.service_a.arn
}

output "iam_service_a_arn" {
  value = aws_iam_role.service_a.arn
}

output "aws_iam_role_service_a_name" {
  value = aws_iam_role.service_a.name
}

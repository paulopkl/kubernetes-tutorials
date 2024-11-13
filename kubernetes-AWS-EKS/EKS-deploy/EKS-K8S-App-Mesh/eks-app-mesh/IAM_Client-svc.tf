# data "aws_iam_policy_document" "service_b" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:client-svc:client-svc"] // "system:serviceaccount:[Namespace]:[Service Account]"
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.eks.arn]
#       type        = "Federated"
#     }
#   }
# }

resource "aws_iam_role" "service_b" {
  name = "${var.env}-${var.eks_name}-eks-client-svc"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:client:client-sa" // "system:serviceaccount:[Namespace]:[Service Account]"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "service_b" {
  name = "AppMeshServiceBAccess"
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

resource "aws_iam_role_policy_attachment" "service_b" {
  role       = aws_iam_role.service_b.name // "${var.env}-${var.eks_name}-eks-client-svc"
  policy_arn = aws_iam_policy.service_b.arn
}

output "iam_service_b_arn" {
  value = aws_iam_role.service_b.arn
}

output "aws_iam_role_service_b_name" {
  value = aws_iam_role.service_b.name
}

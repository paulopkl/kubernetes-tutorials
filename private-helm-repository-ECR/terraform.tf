terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.0"
    }
  }
}

provider "aws" {
  region = var.region # Replace with your desired region
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ECRHelmAccessPolicy"
  description = "Policy to allow ECR Helm chart access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ecr:BatchCheckLayerAvailability", "ecr:GetAuthorizationToken", "ecr:PutImage"]
        Effect   = "Allow"
        Resource = "arn:aws:ecr:${var.region}:${var.account_id}:repository/my-helm-charts"
      },
      {
        Action   = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage"]
        Effect   = "Allow"
        Resource = "arn:aws:ecr:${var.region}:${var.account_id}:repository/my-helm-charts"
      }
    ]
  })
}

resource "aws_iam_role" "helm_ecr_role" {
  name = "HelmECRRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "helm_ecr_policy_attachment" {
  policy_arn = aws_iam_policy.ecr_policy.arn
  role       = aws_iam_role.helm_ecr_role.name
}

resource "aws_ecr_repository" "helm_charts" {
  name = var.ecr_repository_name # Replace with your repository name

  tags = {
    Environment = "production"
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.helm_charts.repository_url
}

## Login to ECR
# aws ecr get-login-password --region us-east-1 | helm registry login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

## Save and push chart
# helm chart save ./my-chart-1.0.0.tgz <account-id>.dkr.ecr.us-east-1.amazonaws.com/my-helm-charts:1.0.0
# helm chart push <account-id>.dkr.ecr.us-east-1.amazonaws.com/my-helm-charts:1.0.0

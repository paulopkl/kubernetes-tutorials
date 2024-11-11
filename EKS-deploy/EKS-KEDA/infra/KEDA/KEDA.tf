resource "kubernetes_namespace" "keda_namespace" {
    metadata {
        name = var.kubernetes_keda_namespace
    }
}

locals {
    k8s_service_account_name = "keda-operator"
    k8s_service_account_namespace = var.kubernetes_keda_namespace

    eks_oidc_issuer = trimprefix(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://")
}

# Get the caller identity so that we can get the AWS Account ID
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_demo_addon_iamserviceaccount_keda" {
    statement {
        actions = ["sts:AssumeRoleWithWebIdentity"]

        principals {
            type = "Federated"
            identifiers = [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.eks_oidc_issuer}"
            ]
        }

        condition {
            test = "StringEquals"
            variable = "${local.eks_oidc_issuer}:sub"
            values = [
                "system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"
            ]
        }

        condition {
            test = "StringEquals"
            variable = "${local.eks_oidc_issuer}:aud"
            values = ["sts.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "eks_iam_role" {
    name = "eks_demo_addon_iamserviceaccount_keda"
    assume_role_policy = data.aws_iam_policy_document.eks_demo_addon_iamserviceaccount_keda.json
}

data "aws_iam_policy" "keda_sqs" {
    name = "keda-sqs"
}

resource "aws_iam_policy_attachment" "attach_get_queue_to_role" {
    name = "attach_get_queue_to_role"
    roles = [aws_iam_role.eks_iam_role.name]
    policy_arn = data.aws_iam_policy.keda_sqs.arn
}

resource "kubernetes_service_account" "iam_role" {
    depends_on = [
        kubernetes_namespace.keda_namespace
    ]

    metadata {
        name = local.k8s_service_account_name
        namespace = local.k8s_service_account_namespace
        annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.eks_iam_role.arn
        }
        labels = {
            "app.kubernetes.io/managed-by": "terraform"
        }
    }
}

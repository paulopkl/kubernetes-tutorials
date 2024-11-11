data "aws_iam_policy_document" "appmesh_gateway" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:gateway:appmesh-gateway"] // "system:serviceaccount:[Namespace]:[Service Account]"
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "appmesh_gateway" {
  name               = "${var.env}-${var.eks_name}-eks-appmesh-gateway"
  assume_role_policy = data.aws_iam_policy_document.appmesh_gateway.json
}

resource "aws_iam_role_policy_attachment" "aws_cloud_map_full_access_gateway" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudMapFullAccess"
  role       = aws_iam_role.appmesh_gateway.name
}

resource "aws_iam_role_policy_attachment" "aws_appmesh_full_access_gateway" {
  policy_arn = "arn:aws:iam::aws:policy/AWSAppMeshFullAccess"
  role       = aws_iam_role.appmesh_gateway.name
}

data "aws_iam_policy_document" "appmesh_controller" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:appmesh-system:appmesh-controller"] // "system:serviceaccount:[Namespace]:[Service Account]"
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "appmesh_controller" {
  name               = "${var.env}-${var.eks_name}-eks-appmesh-controller" // "arn:aws:iam::aws:policy/AWSCloudMapFullAccess/-eks-appmesh-controller"
  assume_role_policy = data.aws_iam_policy_document.appmesh_controller.json
}

resource "aws_iam_role_policy_attachment" "aws_cloud_map_full_access_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudMapFullAccess"
  role       = aws_iam_role.appmesh_controller.name
}

resource "aws_iam_role_policy_attachment" "aws_appmesh_full_access_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AWSAppMeshFullAccess"
  role       = aws_iam_role.appmesh_controller.name
}

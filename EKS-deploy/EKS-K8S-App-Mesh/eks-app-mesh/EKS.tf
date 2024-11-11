resource "aws_eks_cluster" "eks" {
  depends_on = [
    aws_iam_role.eks,
    aws_iam_role_policy_attachment.eks
  ]

  name     = "${var.env}-${var.eks_name}"
  version  = var.eks_version
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.private_zone_1.id,
      aws_subnet.private_zone_2.id,
    ]
  }
}

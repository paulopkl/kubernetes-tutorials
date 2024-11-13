resource "aws_eks_cluster" "demo" {
  depends_on = [
    aws_iam_role_policy_attachment.demo_amazon_eks_cluster_policy
  ]

  name     = var.aws_eks_cluster_name
  version  = "1.29"
  role_arn = aws_iam_role.demo.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private_first_a.id,
      aws_subnet.private_second_b.id,
      aws_subnet.public_first_a.id,
      aws_subnet.public_second_b.id,
    ]
  }
}

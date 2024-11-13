# This returns temporary security credentials just like the previously mentioned AssumeRole API
# This allow POD to autenticate and assume roles in AWS and use his services
# data "aws_iam_policy_document" "csi" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"


#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
#       # "StringEquals": {
#       #   "oidc.eks.us-west-2.amazonaws.com/id/BB2924208FA910F2A41C1A3E01C8F8A4:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
#       # }
#     }

#     # "Federated": "arn:aws:iam::344743739159:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/BB2924208FA910F2A41C1A3E01C8F8A4"
#     principals {
#       identifiers = [aws_iam_openid_connect_provider.eks.arn]
#       type        = "Federated"
#     }
#   }
# }

resource "aws_iam_role" "eks_ebs_csi_driver" {
  name = "AmazonEKS_EBS_CSI_DriverRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${data.aws_iam_openid_connect_provider.eks.url}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
  # assume_role_policy = data.aws_iam_policy_document.csi.json
}

resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
  depends_on = [
    aws_iam_role.eks_ebs_csi_driver
  ]

  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

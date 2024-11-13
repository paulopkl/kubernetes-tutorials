resource "aws_iam_role" "nodes" {
  name = "${var.env}-${var.eks_name}-eks-nodes"

  assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                }
            }
        ]
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

# Optional: only if you want to "SSH" to your EKS nodes.
# resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   role       = aws_iam_role.nodes.name
# }

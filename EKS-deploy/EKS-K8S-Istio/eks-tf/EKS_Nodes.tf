resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

# Optional: only if you want to "SSH" to your EKS nodes.
resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.nodes.name
}

# EKS Node Group
resource "aws_eks_node_group" "private_nodes" {
  depends_on = [
    aws_iam_role_policy_attachment.nodes_amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.nodes_amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.nodes_amazon_ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.amazon_ssm_managed_instance_core,
  ]

  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "private-nodes"

  # AmazonEKSWorkerNodePolicy
  # AmazonEKS_CNI_Policy
  # AmazonEC2ContainerRegistryReadOnly
  # AmazonSSMManagedInstanceCore
  node_role_arn = aws_iam_role.nodes.arn

  # Single subnet to avoid data transfer charges while testing.
  subnet_ids = [
    aws_subnet.private_first_a.id
  ]

  instance_types = [
    "t3.large"
  ]

  # MINIMO - 1
  # MÁXIMO - 3
  # DESEJADO - 2
  scaling_config {
    min_size     = 1
    desired_size = 2
    max_size     = 3
  }

  # MAXIMO de nós indisponiveis durante atualização de node
  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }
}

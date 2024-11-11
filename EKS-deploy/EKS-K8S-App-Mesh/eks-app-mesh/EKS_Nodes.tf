resource "aws_eks_node_group" "general" {
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    aws_eks_cluster.eks
  ]

  cluster_name    = aws_eks_cluster.eks.name
  version         = var.eks_version
  node_group_name = "general"

  
  # AmazonEKSWorkerNodePolicy
  # AmazonEKS_CNI_Policy
  # AmazonEC2ContainerRegistryReadOnly
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    aws_subnet.private_zone_1.id,
    aws_subnet.private_zone_2.id
  ]

  instance_types = ["t3.large"]

  scaling_config {
    min_size     = 1
    desired_size = 2
    max_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}

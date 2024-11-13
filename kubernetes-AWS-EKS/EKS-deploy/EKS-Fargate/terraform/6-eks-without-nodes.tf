resource "aws_iam_role" "eks-cluster" {
  name = "eks-cluster-${var.cluster_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "amazon-eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

## And, of course, the EKS control plane itself. You would need to use our role to create a cluster. Also, if you have a bastion host or VPN configured that allows you to access private IP addresses within the VPC, I would highly recommend enabling a private endpoint.
# I have a video on how to deploy OpenVPN to AWS if you are interested, including how to resolve private Route53 hosted zones. If you still decide to use a public endpoint, you can restrict access using CIDR blocks. Also, specify two private and two public subnets. 
# AWS Fargate can only use private subnets with NAT gateway to deploy your pods. Public subnets can be used for load balancers to expose your
# application to the internet. 

resource "aws_eks_cluster" "cluster" {
  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy]

  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id,
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id
    ]
  }
}

# aws eks update-kubeconfig --name demo --region us-east-1

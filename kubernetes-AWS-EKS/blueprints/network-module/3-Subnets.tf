resource "aws_subnet" "private-region-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "${var.aws_region}a"

  tags = {
    "Name"                                      = "private-${var.aws_region}a"
    "kubernetes.io/role/internal-elb"           = "1"     # Private load balancers
    "kubernetes.io/cluster/${var.cluster_name}" = "owned" # This tag is used by karpenter to discover and autoscale cluster
  }
}

resource "aws_subnet" "private-region-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "${var.aws_region}b"

  tags = {
    "Name"                                      = "private-${var.aws_region}b"
    "kubernetes.io/role/internal-elb"           = "1"     # Private load balancers
    "kubernetes.io/cluster/${var.cluster_name}" = "owned" # This tag is used by karpenter to discover and autoscale cluster
  }
}

resource "aws_subnet" "public-region-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-${var.aws_region}a"
    "kubernetes.io/role/elb"                    = "1"     # Private load balancers
    "kubernetes.io/cluster/${var.cluster_name}" = "owned" # This tag is used by karpenter to discover and autoscale cluster
  }
}

resource "aws_subnet" "public-region-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-${var.aws_region}b"
    "kubernetes.io/role/elb"                    = "1"     # Expose to outside world Public load balancers
    "kubernetes.io/cluster/${var.cluster_name}" = "owned" # This tag is used by karpenter to discover and autoscale cluster
  }
}

output "subnet_ids" {
  description = "List of subnet IDs: public_a, public_b, private_a, private_b"
  value = [
    aws_subnet.private-region-a.id,
    aws_subnet.private-region-b.id,
    aws_subnet.public-region-a.id,
    aws_subnet.public-region-b.id
  ]
}

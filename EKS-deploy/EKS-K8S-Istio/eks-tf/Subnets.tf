resource "aws_subnet" "private_first_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19" # 10.0.0.0 - 10.0.31.255 | 8900 IP's
  availability_zone = "${var.aws_region}a"

  tags = {
    "Name"                                              = "private-${var.aws_region}a"
    "kubernetes.io/role/internal-elb"                   = "1"
    "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private_second_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "${var.aws_region}b"

  tags = {
    "Name"                                              = "private-${var.aws_region}b"
    "kubernetes.io/role/internal-elb"                   = "1"
    "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public_first_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                              = "public-${var.aws_region}a"
    "kubernetes.io/role/elb"                            = "1"
    "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public_second_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                              = "public-${var.aws_region}b"
    "kubernetes.io/role/elb"                            = "1"
    "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "owned"
  }
}

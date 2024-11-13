resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  depends_on = [
    aws_internet_gateway.igw,
    aws_subnet.public_zone_1
  ]

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone_1.id

  tags = {
    Name = "${var.env}-nat"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  depends_on = [
    aws_internet_gateway.igw
  ]

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_first_a.id

  tags = {
    Name = "nat"
  }
}

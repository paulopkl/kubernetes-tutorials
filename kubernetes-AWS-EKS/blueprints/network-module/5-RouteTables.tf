resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "private-region-a" {
  subnet_id      = aws_subnet.private-region-a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-region-b" {
  subnet_id      = aws_subnet.private-region-b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-region-a" {
  subnet_id      = aws_subnet.public-region-a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-region-b" {
  subnet_id      = aws_subnet.public-region-b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_igw" {
  count          = length(var.availability_zones)
  route_table_id = element(aws_route_table.public.*.id, count.index)

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route" "private_was_ngw" {
  count          = length(var.availability_zones)
  route_table_id = element(aws_route_table.private_was.*.id, count.index)

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_nat_gateway.ngw.*.id, count.index)
}

resource "aws_route" "private_db_ngw" {
  count          = length(var.availability_zones)
  route_table_id = element(aws_route_table.private_db.*.id, count.index)

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_nat_gateway.ngw.*.id, count.index)
}

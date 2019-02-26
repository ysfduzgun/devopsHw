#vpc
resource "aws_vpc" "default" {
  cidr_block = "${var.vpcCidr}"
  enable_dns_hostnames = true
}
#internet gateway
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

#### Subnets
#public subnet
resource "aws_subnet" "subnetPublic" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.publicSubnetCidr}"
  tags = {
    Name = "publicSubnet"
  }
}
#private subnet
resource "aws_subnet" "subnetPrivate" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.privateSubnetCidr}"
  tags = {
    Name = "privateSubnet"
  }
}



### nat gateway
resource "aws_eip" "eipForNat" {
  vpc = true
}
resource "aws_nat_gateway" "default" {
  allocation_id = "${aws_eip.eipForNat.id}"
  subnet_id = "${aws_subnet.subnetPublic.id}"
  depends_on = ["aws_internet_gateway.default"]
}

#### Route Tables
#route table for public subnet
resource "aws_route_table" "routeTablePublic" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "${var.anyCidr}"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags = {
    Name = "publicRouteTable"
  }
}
#route table association to public subnet
resource "aws_route_table_association" "routeTablePublic" {
  subnet_id = "${aws_subnet.subnetPublic.id}"
  route_table_id = "${aws_route_table.routeTablePublic.id}"
}

#route table for private subnet
resource "aws_route_table" "routeTablePrivate" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "${var.anyCidr}"
    nat_gateway_id = "${aws_nat_gateway.default.id}"
  }
}
#route table association to private subnet
resource "aws_route_table_association" "routeTablePrivate" {
  subnet_id = "${aws_subnet.subnetPrivate.id}"
  route_table_id = "${aws_route_table.routeTablePrivate.id}"
}

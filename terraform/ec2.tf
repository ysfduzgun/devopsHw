resource "aws_instance" "ubuntu" {
  ami = "ami-0bdf93799014acdc4"
  instance_type = "t2.micro"
  key_name = "${var.awsKey}"
  vpc_security_group_ids = ["${aws_security_group.sgUbuntu.id}"]
  subnet_id = "${aws_subnet.subnetPublic.id}"
  associate_public_ip_address = true
  source_dest_check = false
}

resource "aws_security_group" "sgUbuntu" {
  name = "sgUbuntu"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "sgUbuntu"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.anyCidr}"]
  }
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["${var.publicSubnetCidr}"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.anyCidr}"]
  }

  egress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.privateSubnetCidr}"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.anyCidr}"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.anyCidr}"]
  }
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["${var.publicSubnetCidr}"]
  }
}

output "ubuntuIp" {
  value = "${aws_instance.ubuntu.public_ip}"
}
output "ubuntuIpPrivate" {
  value = "${aws_instance.ubuntu.private_ip}"
}

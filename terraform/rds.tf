resource "aws_db_instance" "mysql" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.6.40"
  instance_class = "db.t2.micro"
  name = "${var.dbName}"
  username = "${var.dbUname}"
  password = "${var.dbPass}"
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"
  vpc_security_group_ids = ["${aws_security_group.sgMysql.id}"]
}

resource "aws_db_subnet_group" "default" {
  name       = "defaultdbg"
  subnet_ids = ["${aws_subnet.subnetPublic.id}","${aws_subnet.subnetPrivate.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "sgMysql" {
  name = "sgMysql"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "sgMysql"
  }

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${aws_security_group.sgUbuntu.id}"]
  }
}

output "mysqlDns" {
  value = "${aws_db_instance.mysql.address}"
}

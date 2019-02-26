resource "aws_elb" "default" {
  name               = "wp-terraform-elb"
  #availability_zones = ["${aws_subnet.subnetPublic.availability_zone_id}"]
  subnets = ["${aws_subnet.subnetPublic.id}"]
  security_groups = ["${aws_security_group.sgLoab.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 6868
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.ubuntu.id}"]
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "wp-terraform-elb"
  }
}


resource "aws_security_group" "sgLoab" {
  name = "sgLoab"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "sgLoab"
  }

  ingress {
    from_port = 6868
    to_port = 6868
    protocol = "tcp"
    cidr_blocks = ["${var.anyCidr}"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.anyCidr}"]
  }
}

output "elbDns" {
  value = "${aws_elb.default.dns_name}"
}

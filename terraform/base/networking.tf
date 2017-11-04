resource "aws_route53_record" "bare_domain" {
  # Attaching a subdomain to an existing zone
  zone_id = "${var.route53_zone_id}"
  name = "${var.domain}"
  type = "A"

  alias {
    name = "${aws_lb.load_balancer.dns_name}"
    zone_id = "${aws_lb.load_balancer.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_security_group" "alb_security_group" {
  name = "rr_alb_group"
  description = "HTTPS in from anywhere, and app ports out to instance"
}

resource "aws_security_group_rule" "alb_https_in" {
  security_group_id = "${aws_security_group.alb_security_group.id}"
  description = "Allow ALB to receive HTTPS connections"

  type = "ingress"
  from_port = "443"
  to_port = "443"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_app_ports_out" {
  count = "${length(var.app_ports)}"
  security_group_id = "${aws_security_group.alb_security_group.id}"
  description = "Allow ALB to make connections to ${element(keys(var.app_ports), count.index)}"

  type = "egress"
  from_port = "${element(values(var.app_ports), count.index)}"
  to_port = "${element(values(var.app_ports), count.index)}"
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.instance_security_group.id}"
}

resource "aws_security_group" "instance_security_group" {
  name = "rr_instance_group"
  description = "App ports in from ALB, SSH & Docker API in from anywhere. DNS, HTTP(s) out to anywhere"
}

resource "aws_security_group_rule" "instance_app_ports_in" {
  count = "${length(var.app_ports)}"
  security_group_id = "${aws_security_group.instance_security_group.id}"
  description = "Allow ${element(keys(var.app_ports), count.index)} to receive connections from ALB"

  type = "ingress"
  from_port = "${element(values(var.app_ports), count.index)}"
  to_port = "${element(values(var.app_ports), count.index)}"
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.alb_security_group.id}"
}

locals {
  instance_global_ingress = "${list("22", "2376")}"
  instance_global_egress = "${list("53", "80", "443")}"
}

resource "aws_security_group_rule" "instance_global_ingress" {
  count = "${length(local.instance_global_ingress)}"
  security_group_id = "${aws_security_group.instance_security_group.id}"
  description = "Allow port ${element(local.instance_global_ingress, count.index)} in from anywhere"

  type = "ingress"
  from_port = "${element(local.instance_global_ingress, count.index)}"
  to_port = "${element(local.instance_global_ingress, count.index)}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "instance_global_egress" {
  count = "${length(local.instance_global_egress)}"
  security_group_id = "${aws_security_group.instance_security_group.id}"
  description = "Allow port ${element(local.instance_global_egress, count.index)} out to anywhere"

  type = "egress"
  from_port = "${element(local.instance_global_egress, count.index)}"
  to_port = "${element(local.instance_global_egress, count.index)}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

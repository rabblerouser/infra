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

resource "aws_security_group" "web" {
  name = "rabble_rouser_web"
  description = "Allow SSH, HTTP(S), and Docker in. Allow DNS and HTTP(S) out."
}

locals {
  ingress_ports = "${concat(values(var.app_ports), list("22", "80", "443", "2376"))}"
  egress_ports = "${concat(values(var.app_ports), list("53", "80", "443"))}"
}

resource "aws_security_group_rule" "ingress_rules" {
  count = "${length(local.ingress_ports)}"
  security_group_id = "${aws_security_group.web.id}"

  type = "ingress"
  from_port = "${element(local.ingress_ports, count.index)}"
  to_port = "${element(local.ingress_ports, count.index)}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_rules" {
  count = "${length(local.egress_ports)}"
  security_group_id = "${aws_security_group.web.id}"

  type = "egress"
  from_port = "${element(local.egress_ports, count.index)}"
  to_port = "${element(local.egress_ports, count.index)}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

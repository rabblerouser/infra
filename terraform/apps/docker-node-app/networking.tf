resource "aws_route53_record" "app_domain" {
  # Attaching a subdomain to an existing zone
  zone_id = "${var.route53_parent_zone_id}"
  name = "${var.name}.${var.parent_domain_name}"
  type = "A"

  alias {
    name = "${data.aws_lb.alb.dns_name}"
    zone_id = "${data.aws_lb.alb.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = "${data.aws_lb_listener.alb_listener.arn}"
  priority = "${var.alb_listener_rule_priority}"

  action {
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
    type = "forward"
  }

  condition {
    field = "host-header"
    values = ["${aws_route53_record.app_domain.name}"]
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name = "rr-alb-${var.name}-target-group"
  port = "${var.port}"
  protocol = "HTTP"
  vpc_id = "${data.aws_vpc.default_vpc.id}"
}

resource "aws_lb_target_group_attachment" "alb_target_attachment" {
  target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  target_id = "${data.aws_instance.instance.id}"
}

resource "aws_route53_record" "app_domain" {
  # Attaching a subdomain to an existing zone
  zone_id = "${var.route53_parent_zone_id}"
  name = "${var.name}.${var.parent_domain_name}"
  type = "A"

  alias {
    name = "${var.alb_dns_name}"
    zone_id = "${var.alb_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = "${var.alb_listener_arn}"
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
  vpc_id = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "alb_target_attachment" {
  target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  target_id = "${var.aws_instance_id}"
}

resource "aws_lb" "load_balancer" {
  name = "rabblerouser-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.web.id}"]

  subnets = ["${data.aws_subnet_ids.default_vpc_subnets.ids}"]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.load_balancer.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${aws_iam_server_certificate.server_cert.arn}"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name = "rabblerouser-alb-target-group"
  port = "443"
  protocol = "HTTPS"
  vpc_id = "${data.aws_vpc.default_vpc.id}"
}

resource "aws_lb_target_group_attachment" "alb_target_bare" {
  target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
  target_id = "${aws_instance.web.id}"
  port = "443"
}

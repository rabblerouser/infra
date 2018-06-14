# This module just contains data resource lookups. This means we can derive information from
# a minimal set of variables, dramatically reducing the amount of stuff we need to pass around

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_instance" "instance" {
  filter {
    name = "ip-address"
    values = ["${var.aws_instance_ip}"]
  }
}

data "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${data.aws_lb.alb.arn}"
  port = 443
}

data "aws_lb" "alb" {
  name = "${replace(var.parent_domain_name, ".", "-")}-alb"
}

data "aws_kinesis_stream" "stream" {
  name = "${var.stream_name}"
}

data "aws_s3_bucket" "archive_bucket" {
  bucket = "${var.archive_bucket_name}"
}

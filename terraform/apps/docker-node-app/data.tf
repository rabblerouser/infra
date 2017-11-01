# This module just contains data resource lookups. This means we can derive information from
# a minimal set of variables, dramatically reducing the amount of stuff we need to pass around

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_instance" "instance" {
  instance_id = "${var.aws_instance_id}"
}

data "aws_lb_listener" "alb_listener" {
  arn = "${var.alb_listener_arn}"
}

data "aws_lb" "alb" {
  arn = "${data.aws_lb_listener.alb_listener.load_balancer_arn}"
}

data "aws_kinesis_stream" "stream" {
  name = "${var.stream_name}"
}

data "aws_s3_bucket" "archive_bucket" {
  bucket = "${var.archive_bucket_name}"
}

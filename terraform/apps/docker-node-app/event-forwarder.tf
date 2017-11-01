module "app_event_forwarder" {
  source = "../event-forwarder"
  name = "${var.name}"
  stream_arn = "${data.aws_kinesis_stream.stream.arn}"
  forward_to = "https://${aws_route53_record.app_domain.fqdn}/events"
}

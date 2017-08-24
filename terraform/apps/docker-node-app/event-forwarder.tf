module "app_event_forwarder" {
  source = "../event-forwarder"
  name = "${var.name}"
  stream_arn = "${var.stream_arn}"
  forward_to = "https://${aws_route53_record.app_domain.fqdn}/events"
}

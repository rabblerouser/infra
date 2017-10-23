module "group_mail_receiver" {
  source = "../../../group-mail-receiver/terraform"
  # source = "github.com/rabblerouser/group-mail-receiver//terraform"

  ses_region = "${var.ses_region}"
  domain = "${var.domain}"
  route53_zone_id = "${var.route53_zone_id}"
}

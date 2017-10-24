module "group_mail_receiver" {
  # These two lines can be toggled to switch between local code and the latest that's on github
  # source = "../../../group-mail-receiver/terraform"
  source = "github.com/rabblerouser/group-mail-receiver//terraform"

  ses_region = "${var.ses_region}"
  domain = "${var.domain}"
  route53_zone_id = "${var.route53_zone_id}"
}

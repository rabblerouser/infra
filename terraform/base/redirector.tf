module "redirector" {
  # These two lines can be toggled to switch between local code and the latest that's on github
  # source = "../../../redirector/terraform"
  source = "github.com/rabblerouser/redirector//terraform"

  region = "${var.region}"
  domain = "${var.domain}"
}

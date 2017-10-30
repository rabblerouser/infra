resource "aws_route53_record" "bare_domain" {
  # Attaching a subdomain to an existing zone
  zone_id = "${var.route53_zone_id}"
  name = "${var.domain}"
  type = "A"

  alias {
    name = "${aws_lb.load_balancer.dns_name}"
    zone_id = "${aws_lb.load_balancer.zone_id}"
    evaluate_target_health = false
  }
}

# The next two resources just look up the default VPC and its subnets, so we can reference them elsewhere
data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_vpc_subnets" {
  vpc_id = "${data.aws_vpc.default_vpc.id}"
}

resource "aws_security_group" "web" {
  name = "rabble_rouser_web"
  description = "Allow SSH, HTTP(S), and Docker in. Allow DNS and HTTP(S) out."

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 2376
    to_port = 2376
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 53
    to_port = 53
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

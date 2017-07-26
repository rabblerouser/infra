resource "aws_route53_record" "bare_domain" {
  # Attaching a subdomain to an existing zone
  zone_id = "${var.route53_zone_id}"
  name = "${var.domain}"
  type = "A"
  ttl = "300" # seconds
  records = ["${aws_eip.eip.public_ip}"]
}

resource "aws_eip" "eip" {
  instance = "${aws_instance.web.id}"
}

resource "aws_security_group" "web" {
  name = "rabble_rouser_web"
  description = "Allow SSH, HTTP(S), and Docker in. Allow DNS, HTTP(S), and Docker out out."

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

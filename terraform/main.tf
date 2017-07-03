terraform {
  backend "s3" {
    # Empty config here because each organisation will configure its own remote state
  }
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "web" {
  ami = "${var.ubuntu[var.region]}"
  instance_type = "t2.small" # Micro does not have enough memory for webpack :(
  key_name = "${aws_key_pair.ansible.key_name}"
  security_groups = ["${aws_security_group.web.name}"]

  tags {
    Name = "Rabble Rouser Web"
  }
}

resource "aws_kinesis_stream" "rabblerouser_stream" {
  name = "rabblerouser_stream"
  shard_count = 1
}

output "ip" {
  value = "${aws_eip.eip.public_ip}"
}

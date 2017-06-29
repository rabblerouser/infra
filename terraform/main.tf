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

resource "aws_iam_policy" "put_to_stream" {
  name = "put_to_stream"
  path = "/"
  description = "Allows write access to the Rabble Rouser stream"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Action": "kinesis:PutRecord",
      "Resource": "${aws_kinesis_stream.rabblerouser_stream.arn}"
  }]
}
EOF
}

output "ip" {
  value = "${aws_eip.eip.public_ip}"
}

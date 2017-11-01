resource "aws_instance" "web" {
  ami = "${var.ubuntu[var.region]}"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.ansible.key_name}"
  security_groups = ["${aws_security_group.web.name}"]

  tags {
    Name = "Rabble Rouser Web"
  }
}

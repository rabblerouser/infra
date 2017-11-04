resource "aws_instance" "web" {
  ami = "${var.ubuntu[var.region]}"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.ec2_ssh_key_pair.key_name}"
  security_groups = ["${aws_security_group.instance_security_group.name}"]

  tags {
    Name = "Rabble Rouser Web"
  }
}

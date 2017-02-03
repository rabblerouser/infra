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

resource "random_id" "core_db_password" {
  keepers = {
    # Generate a new password when building a new EC2 instance
    ec2_instance_id = "${aws_instance.web.id}"
  }
  byte_length = 32
}

resource "aws_db_instance" "db" {
  instance_class = "db.t2.micro"
  allocated_storage = 20
  storage_type = "gp2"
  multi_az = false

  engine = "postgres"
  engine_version = "9.5.4"

  name = "rabble_rouser"
  username = "rabble_rouser"
  password = "${random_id.core_db_password.hex}"
  port = 5432

  vpc_security_group_ids = ["${aws_security_group.rds.id}"]

  # This doesn't work with db.t2.micro
  # storage_encrypted = true
}

resource "aws_kinesis_stream" "rabblerouser_stream" {
  name = "rabblerouser_stream"
  shard_count = 1
}

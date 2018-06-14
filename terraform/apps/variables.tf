variable "domain" {
  description = "The domain where you want your Rabble Rouser instance to live. Must be valid for the host zone where it will be created. E.g. if the hosted zone is example.com, then this variable might be set to 'rabblerouser.example.com'. Do not include a trailing period on the end of the domain name."
  type = "string"
}

variable "route53_zone_id" {
  description = "An existing Route53 hosted zone, where the new DNS entry should be placed"
  type = "string"
}

variable "app_ports" {
  description = "A map of ports, specified as app_name => port_number"
  type = "map"
}

variable "aws_instance_ip" {
  description = "The public IP address of the EC2 instance where this app should be deployed"
  type = "string"
}

variable "docker_credentials" {
  description = "The key, ca, and cert PEMs used to authenticate with the remote Docker daemon"
  type = "map"
}

variable "stream_name" {
  description = "The name of the kinesis event stream"
  type = "string"
}

variable "archive_bucket_name" {
  description = "The name of the event archive bucket"
  type = "string"
}

variable "ses_region" {
  description = "The AWS region where SES will be used. SES region availability is quite limited"
  default = "us-east-1"
}

variable "mail_bucket_name" {
  description = "The name of the mail storage bucket"
  type = "string"
}

variable "group_mail_receiver_auth_token" {
  description = "The token used to authenticate requests from the group-mail-receiver to the group-mailer"
  type = "string"
}

variable "route53_zone_id" {
  description = "An existing Route53 hosted zone, where the new DNS entry should be placed"
  type = "string"
}

variable "tls_cert_email" {
  description = "The email under which to register the TLS cert. E.g. webmaster@rabblerouser.team"
  type = "string"
}

variable "domain" {
  description = "The domain where you want your Rabble Rouser instance to live. Must be valid for the host zone where it will be created. E.g. if the hosted zone is example.com, then this variable might be set to 'rabblerouser.example.com'. Do not include a trailing period on the end of the domain name."
  type = "string"
}

variable "private_key_path" {
  description = "Private key to be used for ansible provisioning"
  default = "~/.ssh/id_rsa"
}

variable "public_key_path" {
  description = "Public key to be used for ansible provisioning"
  default = "~/.ssh/id_rsa.pub"
}

variable "region" {
  description = "The AWS region to create all the infrastructure in"
  default = "ap-southeast-2"
}

variable "ses_region" {
  description = "The AWS region where SES will be used. SES region availability is quite limited"
  default = "us-east-1"
}

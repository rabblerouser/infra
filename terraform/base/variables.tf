variable "route53_zone_id" {
  description = "An existing Route53 hosted zone, where the new DNS entry should be placed"
  type = "string"
}

variable "domain" {
  description = "The domain where you want your Rabble Rouser instance to live. Must be valid for the host zone where it will be created. E.g. if the hosted zone is example.com, then this variable might be set to 'rabblerouser.example.com'. Do not include a trailing period on the end of the domain name."
  type = "string"
}

variable "private_key_path" {
  description = "Private key to be used for ansible provisioning"
  type = "string"
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

variable "ubuntu" {
  description = "Ubuntu 16.04 (HVM, EBS). Sourced from https://cloud-images.ubuntu.com/locator/ec2/"
  type = "map"
  default = {
    ap-northeast-1 = "ami-0567c164" # Tokyo
    ap-southeast-1 = "ami-a1288ec2" # Singapore
    ap-southeast-2 = "ami-4d3b062e" # Sydney

    eu-central-1 = "ami-8504fdea" # Frankfurt
    eu-west-1 = "ami-0d77397e" # Ireland

    sa-east-1 = "ami-e93da085" # São Paulo

    us-east-1 = "ami-40d28157"  # N. Virginia
    us-west-1 = "ami-6e165d0e" # N. California
    us-west-2 = "ami-a9d276c9" # Oregon

    cn-north-1 = "ami-d9f226b4" # Beijing
  }
}

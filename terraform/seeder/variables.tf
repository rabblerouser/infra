variable "host_ip" {
  description = "The IP address of the host where the seeder should run"
  type = "string"
}

variable "stream_arn" {
  description = "The ARN of the kinesis event stream"
  type = "string"
}

variable "stream_name" {
  description = "The name of the kinesis event stream"
  type = "string"
}

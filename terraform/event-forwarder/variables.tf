variable "stream_arn" {
  description = "The ARN of the kinesis stream where events come from"
  type = "string"
}

variable "name" {
  description = "The name to give the created lambda function"
  type = "string"
}

variable "forward_to" {
  description = "The endpoint where events should be forwarded to, e.g. https://rr.example.com/events"
  type = "string"
}

resource "aws_kinesis_stream" "rabblerouser_stream" {
  # Don't change this name - the apps use it to look up the stream
  name = "${replace(var.domain, ".", "-")}-stream"
  shard_count = 1
}

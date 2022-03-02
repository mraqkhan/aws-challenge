resource "aws_kinesis_stream" "pbdemo_kinesis_streams" {
  for_each         = toset(var.kinesis_stream_names)
  name             = "${each.key}_${terraform.workspace}"
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Name        = each.key
    Environment = "${terraform.workspace}"
  }
}
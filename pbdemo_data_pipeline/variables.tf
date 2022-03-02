variable "kinesis_stream_names" {
  type    = list(string)
  default = ["pbdemo_kinesis_stream", "pbdemo_kinesis_aggregate_stream"]
}

variable "aws_s3_bucket_name" {
  description = "s3 bucket name"
  type        = string
  default     = "pbdemo-athena-data-tf-aq"
}

variable "pbdemo_kinesis_firehose_s3_stream" {
  description = "kinesis firehose stream"
  type        = string
  default     = "pbdemo_kinesis_firehose_stream"
}

variable "aws_dynamo_read_capacity" {
  description = "dynamo table read capacity"
  type        = number
  default     = 1
}

variable "aws_dynamo_write_capacity" {
  description = "dynamo table write capacity"
  type        = number
  default     = 1
}
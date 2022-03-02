resource "aws_kinesis_firehose_delivery_stream" "pbdemo_kinesis_firehose_s3_stream" {
  name        = var.pbdemo_kinesis_firehose_s3_stream
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn        = aws_iam_role.pbdemo_kinesis_firehose_role.arn
    bucket_arn      = aws_s3_bucket.pbdemo_athena_data_s3_bucket.arn
    buffer_interval = 60
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.pbdemo_kinesis_streams[var.kinesis_stream_names[0]].arn
    role_arn           = aws_iam_role.pbdemo_kinesis_firehose_role.arn
  }
}

resource "aws_iam_role" "pbdemo_kinesis_firehose_role" {
  name = "PBDemoKinesisFirehoseRole"

  assume_role_policy = file("aws_roles_and_policies/pbdemo_kinesis_firehose_role.json")

}

data "template_file" "pbdemo_kinesis_firehose_role_policy_template" {
  template = file("aws_roles_and_policies/pbdemo_kinesis_firehose_role_policy.json.tpl")

  vars = {
    s3_bucket               = aws_s3_bucket.pbdemo_athena_data_s3_bucket.arn
    kinesis_read_stream_arn = aws_kinesis_stream.pbdemo_kinesis_streams[var.kinesis_stream_names[0]].arn
  }
}

resource "aws_iam_role_policy" "pbdemo_kinesis_firehose_role_policy" {
  name = "PBDemoKinesisFirehoseRolePolicy"
  role = aws_iam_role.pbdemo_kinesis_firehose_role.id

  policy = data.template_file.pbdemo_kinesis_firehose_role_policy_template.rendered

}

data "template_file" "pbdemo_kinesis_dynamodb_write_policy_template" {
  template = file("aws_roles_and_policies/pbdemo_kinesis_dynamodb_write_policy.json.tpl")

  vars = {
    pbdemo_dynamodb_table_arn = aws_dynamodb_table.pbdemo_dynamodb_table.arn
  }
}

resource "aws_iam_policy" "pbdemo_kinesis_dynamodb_write_policy" {
  name = "PBDemoKinesisDynamoDBWritePolicy"

  policy = data.template_file.pbdemo_kinesis_dynamodb_write_policy_template.rendered

}

resource "aws_iam_role" "pbdemo_kinesis_stream_processor_role" {
  name = "PBDemoKinesisStreamProcessorRole"

  assume_role_policy = file("aws_roles_and_policies/pbdemo_kinesis_stream_processor_role.json")

}

resource "aws_iam_role_policy_attachment" "pbdemo_kinesis_dynamodb_write_policy_attach" {
  role       = aws_iam_role.pbdemo_kinesis_stream_processor_role.name
  policy_arn = aws_iam_policy.pbdemo_kinesis_dynamodb_write_policy.arn
}

resource "aws_iam_role_policy_attachment" "pbdemo_kinesis_lambda_execution_role_attach" {
  role       = aws_iam_role.pbdemo_kinesis_stream_processor_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

resource "aws_lambda_event_source_mapping" "pbdemo_kinesis_lambda_event_mapping" {
  event_source_arn  = aws_kinesis_stream.pbdemo_kinesis_streams[var.kinesis_stream_names[1]].arn
  function_name     = aws_lambda_function.pbdemo_kinesis_stream_processor.arn
  starting_position = "LATEST"
}
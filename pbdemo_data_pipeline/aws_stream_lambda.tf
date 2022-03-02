data "archive_file" "pbdemo_lambda_zip_archive" {
  source_dir  = "./code/kinesis_stream_lambda/handler/"
  output_path = "./code/kinesis_stream_lambda/handler-${terraform.workspace}.zip"
  type        = "zip"
}

resource "aws_lambda_function" "pbdemo_kinesis_stream_processor" {
  function_name = "PBDemoKinesisStreamProcessor-${terraform.workspace}"
  role          = aws_iam_role.pbdemo_kinesis_stream_processor_role.arn
  handler       = "aws_lambda.lambda_handler"
  timeout       = 60

  filename         = data.archive_file.pbdemo_lambda_zip_archive.output_path
  source_code_hash = data.archive_file.pbdemo_lambda_zip_archive.output_base64sha256

  runtime = "python3.9"

  environment {
    variables = {
      Environment = "${terraform.workspace}"
      TABLE_NAME  = aws_dynamodb_table.pbdemo_dynamodb_table.name
    }
  }
}

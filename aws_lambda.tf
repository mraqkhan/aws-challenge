data "archive_file" "aws_challange_lambda_zip_archive" {
  source_dir  = "./code/geo_data_s3_lambda/handler/"
  output_path = "./code/geo_data_s3_lambda/handler-${terraform.workspace}.zip"
  type        = "zip"
}

resource "aws_lambda_function" "aws_lambda_geo_location_processor" {
  function_name = "aws-challange-geo-location-processor-${terraform.workspace}"
  role          = aws_iam_role.aws_challange_lambda_assume_role.arn
  handler       = "aws_lambda.lambda_handler"
  timeout       = 60

  filename         = "${data.archive_file.aws_challange_lambda_zip_archive.output_path}"
  source_code_hash = "${data.archive_file.aws_challange_lambda_zip_archive.output_base64sha256}"

  runtime = "python3.9"

  environment {
    variables = {
      Environment = "${terraform.workspace}"
      API_URL = "${var.api_url}"
      S3_Bucket = "${aws_s3_bucket.lambda_s3_bucket.bucket}"
      S3_Object = "${var.s3_object_name}"
    }
  }
}

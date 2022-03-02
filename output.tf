output "deployed_environment" {
  description = "Printing deployed env"
  value       = terraform.workspace
}

output "lambda_api_gw_call_url" {
  description = "Call URL for lambda via API Gateway stage."

  value = "${aws_apigatewayv2_stage.aws_lambda_api_gw_stage.invoke_url}/sort"
}

output "s3_object_public_url" {
  description = "Public URL for sorted json object in s3 bucket"
  value       = "https://${aws_s3_bucket.aws_lambda_s3_bucket.bucket}.s3.amazonaws.com/${var.aws_s3_object_name}"
}
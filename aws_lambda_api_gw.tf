resource "aws_apigatewayv2_api" "aws_lambda_api_gw" {
  name          = var.aws_lambda_api_gw
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "aws_lambda_api_gw_stage" {
  api_id      = aws_apigatewayv2_api.aws_lambda_api_gw.id
  name        = "${var.aws_lambda_api_gw_stage}_${terraform.workspace}"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "aws_lambda_api_gw_integration" {
  api_id             = aws_apigatewayv2_api.aws_lambda_api_gw.id
  integration_uri    = aws_lambda_function.aws_lambda_geo_location_processor.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "aws_lambda_api_gw_route" {
  api_id    = aws_apigatewayv2_api.aws_lambda_api_gw.id
  route_key = var.aws_lambda_api_gw_route
  target    = "integrations/${aws_apigatewayv2_integration.aws_lambda_api_gw_integration.id}"
}

resource "aws_lambda_permission" "aws_lambda_api_gw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_lambda_geo_location_processor.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.aws_lambda_api_gw.execution_arn}/*/*"
}

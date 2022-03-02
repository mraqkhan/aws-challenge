variable "env" {
  description = "Environment tag for deployment"
  type        = string
  default     = "dev"
}

variable "aws_deployment_region" {
  description = "aws region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_deployment_profile" {
  description = "aws region to deploy resources"
  type        = string
  default     = "default"
}

variable "aws_s3_object_name" {
  description = "s3 object name in bucket"
  type        = string
  default     = "aws_challange_sorted.json"
}

variable "aws_s3_bucket_name" {
  description = "s3 bucket name"
  type        = string
  default     = "aws-challange-s3-aq"
}

variable "aws_lambda_api_gw" {
  description = "lambda api gw name"
  type        = string
  default     = "aws_lambda_api_gw"
}

variable "aws_lambda_api_gw_stage" {
  description = "lambda api gw stage name"
  type        = string
  default     = "aws_lambda_api_gw_stage"
}

variable "aws_lambda_api_gw_route" {
  description = "lambda api gw route"
  type        = string
  default     = "GET /sort"
}

variable "aws_lambda_geo_location_processor" {
  description = "lambda func name"
  type        = string
  default     = "aws-challange-geo-location-processor"
}

variable "api_url" {
  description = "API URL to fetch geo data"
  type        = string
  default     = "http://pb-coding-challenge.s3-website.eu-central-1.amazonaws.com/metadata-sparse.json"
}

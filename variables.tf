variable "env" {
  description = "Environment tag for deployment"
  type        = string
  default     = "dev"
}

variable "s3_object_name" {
  description = "s3 object name in bucket"
  type        = string
  default     = "aws_challange_sorted.json"
}

variable "api_url" {
  description = "API URL to fetch geo data"
  type        = string
  default     = "http://pb-coding-challenge.s3-website.eu-central-1.amazonaws.com/metadata-sparse.json"
}
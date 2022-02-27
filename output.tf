output "deployed_environment" {
  description = "Printing deployed env"
  value       = terraform.workspace
}

output "s3_object_public_url" {
  description = "ID of the EC2 instance"
  value       = "https://${aws_s3_bucket.lambda_s3_bucket.bucket}.s3.amazonaws.com/${var.s3_object_name}"
}
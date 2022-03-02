resource "aws_dynamodb_table" "pbdemo_dynamodb_table" {
  name           = "PBDemoKinesisDynamoTable-${terraform.workspace}"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.aws_dynamo_read_capacity
  write_capacity = var.aws_dynamo_write_capacity
  hash_key       = "Name"
  range_key      = "StatusTime"

  attribute {
    name = "Name"
    type = "S"
  }

  attribute {
    name = "StatusTime"
    type = "S"
  }

  tags = {
    Name        = "Dynamo Table for PB Demo"
    Environment = "${terraform.workspace}"
  }
}

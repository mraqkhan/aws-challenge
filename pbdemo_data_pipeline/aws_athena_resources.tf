resource "aws_athena_database" "pbdemo_athena_firehose_db" {
  name          = "pbdemo_athena_firehose_db_${terraform.workspace}"
  bucket        = aws_s3_bucket.pbdemo_athena_data_s3_bucket.bucket
  force_destroy = true
}

resource "null_resource" "pbdemo_athena_firehose_table" {

  provisioner "local-exec" {
    command = <<EOF
aws athena start-query-execution --query-string "CREATE EXTERNAL TABLE IF NOT EXISTS pbdemo (Name string,StatusTime timestamp,Latitude float,Longitude float,Distance float,CashPoints int,Balance int) ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' LOCATION 's3://${aws_s3_bucket.pbdemo_athena_data_s3_bucket.bucket}/';" --output json --query-execution-context Database=${aws_athena_database.pbdemo_athena_firehose_db.id} --result-configuration OutputLocation=s3://${aws_s3_bucket.pbdemo_athena_data_s3_bucket.bucket}/athena
     EOF
  }
}

resource "aws_athena_named_query" "athena_demo_query" {
  name     = "pbdemo_athena_query"
  database = aws_athena_database.pbdemo_athena_firehose_db.name
  query    = "SELECT * FROM pbdemo;"
}
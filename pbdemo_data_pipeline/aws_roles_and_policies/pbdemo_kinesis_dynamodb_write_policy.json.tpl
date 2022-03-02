{
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "dynamodb:BatchWriteItem",
        "Resource" : "${pbdemo_dynamodb_table_arn}"
      }
    ]
  }
{
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ReadInputKinesis",
        "Effect" : "Allow",
        "Action" : [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords"
        ],
        "Resource" : [
          "${kinesis_read_stream_arn}"
        ]
      },
      {
        "Sid" : "WriteOutputKinesis",
        "Effect" : "Allow",
        "Action" : [
          "kinesis:DescribeStream",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ],
        "Resource" : [
          "${kinesis_write_stream_arn}"
        ]
      }
    ]
  }
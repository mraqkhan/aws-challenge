resource "aws_kinesis_analytics_application" "pbdemo_analytics_app" {
  name = "pbdemo_analytics_app_${terraform.workspace}"
  code = "CREATE OR REPLACE STREAM \"DESTINATION_SQL_DATA_STREAM\" (\n  \"Name\"                VARCHAR(64),\n  \"StatusTime\"          TIMESTAMP,\n  \"Distance\"            SMALLINT,\n  \"MinCashPoints\"      SMALLINT,\n  \"MaxCashPoints\"      SMALLINT,\n  \"MinBalance\"     SMALLINT,\n  \"MaxBalance\"     SMALLINT\n);\n\nCREATE OR REPLACE PUMP \"STREAM_PUMP\" AS\n  INSERT INTO \"DESTINATION_SQL_DATA_STREAM\"\n    SELECT STREAM \"Name\", \"ROWTIME\", SUM(\"Distance\"), MIN(\"CashPoints\"),\n                  MAX(\"CashPoints\"), MIN(\"Balance\"), MAX(\"Balance\")\n    FROM \"SOURCE_SQL_DATA_STREAM_001\"\n    GROUP BY FLOOR(\"SOURCE_SQL_DATA_STREAM_001\".\"ROWTIME\" TO MINUTE), \"Name\";\n"

  inputs {
    name_prefix = "SOURCE_SQL_DATA_STREAM"

    kinesis_stream {
      resource_arn = aws_kinesis_stream.pbdemo_kinesis_streams[var.kinesis_stream_names[0]].arn
      role_arn     = aws_iam_role.pbdemo_kinesis_analytics_app_role.arn
    }

    starting_position_configuration {
      starting_position = "NOW"
    }

    schema {
      record_columns {
        mapping  = "$.Distance"
        name     = "Distance"
        sql_type = "DOUBLE"
      }
      record_columns {
        mapping  = "$.CashPoints"
        name     = "CashPoints"
        sql_type = "INTEGER"
      }
      record_columns {
        mapping  = "$.Latitude"
        name     = "Latitude"
        sql_type = "DOUBLE"
      }
      record_columns {
        mapping  = "$.Longitude"
        name     = "Longitude"
        sql_type = "DOUBLE"
      }
      record_columns {
        mapping  = "$.Balance"
        name     = "Balance"
        sql_type = "INTEGER"
      }
      record_columns {
        mapping  = "$.Name"
        name     = "Name"
        sql_type = "VARCHAR(64)"
      }
      record_columns {
        mapping  = "$.StatusTime"
        name     = "StatusTime"
        sql_type = "TIMESTAMP"
      }

      record_encoding = "UTF-8"

      record_format {
        mapping_parameters {
          json {
            record_row_path = "$"
          }
        }
      }
    }
  }
  outputs {
    name = "DESTINATION_SQL_DATA_STREAM"

    schema {
      record_format_type = "JSON"
    }

    kinesis_stream {
      resource_arn = aws_kinesis_stream.pbdemo_kinesis_streams[var.kinesis_stream_names[1]].arn
      role_arn     = aws_iam_role.pbdemo_kinesis_analytics_app_role.arn
    }
  }

  start_application = true
}

resource "aws_iam_role" "pbdemo_kinesis_analytics_app_role" {
  name = "PBDemoKinesisAnalyticsAppRole"

  assume_role_policy = file("aws_roles_and_policies/pbdemo_kinesis_analytics_app_role.json")

  tags = {
    Environment = "${terraform.workspace}"
  }
}

data "template_file" "pbdemo_kinesis_analytics_role_policy_template" {
  template = file("aws_roles_and_policies/pbdemo_kinesis_analytics_role_policy.json.tpl")

  vars = {
    kinesis_write_stream_arn = aws_kinesis_stream.pbdemo_kinesis_streams[var.kinesis_stream_names[1]].arn
    kinesis_read_stream_arn  = aws_kinesis_stream.pbdemo_kinesis_streams[var.kinesis_stream_names[0]].arn
  }
}

resource "aws_iam_role_policy" "pbdemo_kinesis_analytics_role_policy" {
  name = "PBDemoKinesisAnalyticsRolePolicy"
  role = aws_iam_role.pbdemo_kinesis_analytics_app_role.id

  policy = data.template_file.pbdemo_kinesis_analytics_role_policy_template.rendered
}

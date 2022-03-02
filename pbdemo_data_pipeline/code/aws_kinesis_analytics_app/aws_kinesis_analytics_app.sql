CREATE OR REPLACE STREAM "DESTINATION_SQL_DATA_STREAM" (
  "Name"                VARCHAR(16),
  "StatusTime"          TIMESTAMP,
  "Distance"            SMALLINT,
  "MinCashPoints"      SMALLINT,
  "MaxCashPoints"      SMALLINT,
  "MinBalance"     SMALLINT,
  "MaxBalance"     SMALLINT
);

CREATE OR REPLACE PUMP "STREAM_PUMP" AS
  INSERT INTO "DESTINATION_SQL_DATA_STREAM"
    SELECT STREAM "Name", "ROWTIME", SUM("Distance"), MIN("CashPoints"),
                  MAX("CashPoints"), MIN("Balance"), MAX("Balance")
    FROM "SOURCE_SQL_DATA_STREAM_001"
    GROUP BY FLOOR("SOURCE_SQL_DATA_STREAM_001"."ROWTIME" TO MINUTE), "Name";
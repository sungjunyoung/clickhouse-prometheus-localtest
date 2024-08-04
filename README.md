# Clickhouse Prometheus LocalTest

```bash
# your clickhouse server binary location
CLICKHOUSE_SERVER_BINARY=/Users/sungjunyoung/Sources/opensource/ClickHouse/build/programs/clickhouse-server make clickhouse

# run prometheus remote writer / remote reader
make up
```
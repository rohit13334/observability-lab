# OpenTelemetry Collector

Central telemetry pipeline.

## Role
- Receives traces/metrics/logs
- Processes data
- Sends to Tempo/Prometheus

## Ports
- 4317 (gRPC)
- 4318 (HTTP)

## Flow
App → Collector → Tempo

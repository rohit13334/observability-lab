# Tempo

Distributed tracing backend.

## Purpose
- Stores traces from OTel Collector
- Provides query API for Grafana

## Port
- 3200 (HTTP API)

## Health check
```bash
curl http://localhost:3200/ready

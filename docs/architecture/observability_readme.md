# Observability Stack

This folder contains full observability infrastructure:

- OpenTelemetry Collector
- Grafana
- Prometheus
- Tempo

## Start stack

```bash
docker compose up -d


Final architecture (simple mental model)

          [ Spring Boot App ]
                   │
                   ▼
        OpenTelemetry Java Agent
                   │
                   ▼
        OpenTelemetry Collector
                   │
     ┌─────────────┼─────────────┐
     ▼             ▼             ▼
  Tempo       Prometheus     Logs (later)
     │
     ▼
  Grafana

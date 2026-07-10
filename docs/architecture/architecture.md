# Observability Lab Architecture

This lab demonstrates full-stack observability for a Spring Boot application using OpenTelemetry, Tempo, Prometheus, and Grafana.

## High Level Flow

Spring PetClinic Application
        │
        │ (OTLP HTTP/gRPC 4317)
        ▼
OpenTelemetry Java Agent
        │
        ▼
OpenTelemetry Collector
        │
        ├──▶ Tempo (Traces)
        ├──▶ Prometheus (Metrics - later)
        └──▶ Grafana (Visualization)

---

## Components

### 1. Spring PetClinic
- Sample Spring Boot application
- Generates HTTP requests, DB calls, services

### 2. OpenTelemetry Java Agent
- Auto-instruments application
- No code changes required

### 3. OpenTelemetry Collector
- Receives telemetry
- Processes & exports data
- Acts as pipeline hub

### 4. Tempo
- Distributed tracing backend
- Stores and queries traces

### 5. Prometheus
- Metrics storage (future step)

### 6. Grafana
- Visualization layer
- Displays traces, metrics, dashboards

---

## Ports

| Service | Port |
|--------|------|
| Grafana | 3000 |
| Prometheus | 9090 |
| Tempo | 3200 |
| OTel Collector | 4317 / 4318 |
| PetClinic App | 8080 |

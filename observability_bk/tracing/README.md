# Distributed Tracing

This directory contains tracing components for:

- OpenTelemetry
- Tempo
- OTLP collectors
- Trace ingestion

---

# Components

## Tempo

Stores distributed traces.

---

## OpenTelemetry Collector

Receives and exports traces.

---

# Trace Flow

```text
Application
    ↓
OTEL SDK
    ↓
OTEL Collector
    ↓
Tempo
    ↓
Grafana
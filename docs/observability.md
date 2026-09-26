# Observability architecture

## Golden signals

Every API service must expose:

- request rate
- error rate
- latency
- saturation

## Backend

Required:
- OpenTelemetry SDK
- W3C trace context
- structured JSON logs
- Prometheus metrics
- trace/span IDs in logs
- health/readiness/startup endpoints

## Kubernetes

Monitor:
- node health
- pod restarts
- OOMKills
- CPU throttling
- memory pressure
- scheduling failures
- HPA status
- PDB violations
- deployment availability
- ingress 4xx/5xx
- ingress latency

## AWS

Monitor:
- ALB target health
- ALB response time
- ALB 4xx/5xx
- RDS CPU/connections/storage/latency
- Redis memory/evictions/connections
- SQS queue depth/age
- CloudFront 4xx/5xx/latency

## Android

Required mobile telemetry:
- crash-free sessions
- crash-free users
- ANR rate
- startup time
- screen rendering
- API failures
- network failures
- device/OS dimensions

## Web

Monitor:
- LCP
- INP
- CLS
- JS exceptions
- API latency
- navigation timing

## Business

Examples:
- login success rate
- registration success rate
- search success rate
- job application success rate
- payment success rate

## Trace correlation

Every request should preserve:

```text
traceparent
```

Logs must include:

```json
{
  "trace_id": "...",
  "span_id": "...",
  "service": "job-service",
  "environment": "prod"
}
```

## Release gates

For backend canary:
- 5xx ratio
- p95 latency
- pod restarts
- readiness failures

For Android:
- crash rate
- ANR
- startup time
- API error rate
- business transaction success

A rollback decision must be automated where the signal is deterministic, otherwise controlled by an on-call engineer.

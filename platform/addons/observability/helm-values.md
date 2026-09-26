# Observability Helm configuration

Install with Helm/Argo CD:

- kube-prometheus-stack
- OpenTelemetry Operator
- OpenTelemetry Collector

Production exporters should be configured for the selected telemetry backend.

Do not use the `debug` exporter as the long-term production destination.

Recommended production destinations:

- AWS Managed Prometheus for metrics
- AWS X-Ray or an OpenTelemetry-compatible trace backend
- CloudWatch/OpenSearch for logs
- Grafana for visualization

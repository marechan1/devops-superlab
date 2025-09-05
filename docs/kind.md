# Local Cluster (kind)

Creates a 3-node cluster, installs metrics-server, ingress-nginx, and an observability stack:
- kube-prometheus-stack (Prometheus, Alertmanager, Grafana)
- Loki/Promtail (logs), Tempo (traces)
- OpenTelemetry Collector

```bash
make kind-up
```

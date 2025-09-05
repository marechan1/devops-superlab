#!/usr/bin/env bash
set -euo pipefail
CLUSTER=superlab
echo "==> creating kind cluster: $CLUSTER"
cat <<K > /tmp/kind.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${CLUSTER}
nodes:
- role: control-plane
- role: worker
- role: worker
K
kind create cluster --config /tmp/kind.yaml || true

echo "==> metrics-server"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl -n kube-system patch deployment metrics-server --type='json' -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]' || true

echo "==> ingress-nginx"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade -i ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace

echo "==> kube-prometheus-stack (Prometheus + Grafana + Alertmanager)"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade -i monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

echo "==> Loki + Promtail"
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade -i loki grafana/loki -n observability --create-namespace --set isDefault=true
helm upgrade -i promtail grafana/promtail -n observability --set loki.serviceName=loki

echo "==> Tempo"
helm upgrade -i tempo grafana/tempo -n observability --set persistence.enabled=false

echo "==> OpenTelemetry Collector (gateway)"
kubectl apply -n observability -f - <<'YAML'
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-collector-conf
  namespace: observability
data:
  config.yaml: |
    receivers:
      otlp:
        protocols: { http: {}, grpc: {} }
    processors:
      batch: {}
    exporters:
      otlp:
        endpoint: tempo.observability.svc.cluster.local:4317
        tls: { insecure: true }
      logging: { loglevel: info }
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch]
          exporters: [logging, otlp]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: otel-collector
  namespace: observability
spec:
  replicas: 1
  selector: { matchLabels: { app: otel-collector } }
  template:
    metadata: { labels: { app: otel-collector } }
    spec:
      containers:
        - name: otc
          image: otel/opentelemetry-collector:latest
          args: [ "--config=/conf/config.yaml" ]
          ports:
            - containerPort: 4317
            - containerPort: 4318
          volumeMounts: [ { name: conf, mountPath: /conf } ]
      volumes: [ { name: conf, configMap: { name: otel-collector-conf } } ]
---
apiVersion: v1
kind: Service
metadata:
  name: otel-collector
  namespace: observability
spec:
  selector: { app: otel-collector }
  ports:
    - name: grpc
      port: 4317
      targetPort: 4317
    - name: http
      port: 4318
      targetPort: 4318
YAML
echo "[ok] kind + observability ready"

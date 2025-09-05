# DevOps Superlab

> Enterprise-style demo stack for CI/CD, GitOps, Kustomize, HPAs, Observability, and Security — built to impress.

**Highlights**
- CI/CD → tests, Docker Buildx → GHCR, SBOMs & scans (Trivy, Syft/Grype)
- Kustomize overlays (dev/stage/prod) with HorizontalPodAutoscalers (HPA)
- Helm umbrella (+ OCI registry) and per-app charts
- kind bootstrap + metrics-server + ingress + observability (Prom/Grafana, Loki, Tempo, OTEL)
- GitOps (Argo CD), Policy (Gatekeeper) + Conftest, pre-commit, Renovate

## Quick peek

```bash
make bootstrap
make kind-up
fish scripts/kustomize-apply-dev.fish
kubectl -n superlab-dev get deploy,svc,hpa
```

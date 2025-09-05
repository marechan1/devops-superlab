# Argo CD (GitOps)

Bootstrap Argo CD and a root App targeting `kustomize/overlays/dev`:

```bash
make argocd-bootstrap
```

Once up, point Argo CD at this repo (read-only token) and watch sync.

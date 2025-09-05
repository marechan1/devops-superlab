# Policy

Included:
- **Gatekeeper** constraint: require CPU/Memory requests & limits
- **Conftest (Rego)**: Deployment container images must use the `ghcr.io/` registry

Validate:

```bash
make gatekeeper-bootstrap
kubectl kustomize kustomize/overlays/dev | conftest test -p policies/conftest -
```

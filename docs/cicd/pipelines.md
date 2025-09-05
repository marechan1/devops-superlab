# CI/CD Pipelines

- **Build & Test**: language unit tests, Docker Buildx
- **Security**: Trivy (fs/config/image), Checkov for IaC
- **Kustomize Validate**: kubeconform against overlays
- **SBOM**: Syft → upload as artifact
- **Docs**: MkDocs → GitHub Pages

Workflows live in `.github/workflows/`.

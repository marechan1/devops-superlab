# Quickstart

1) **Bootstrap**
```bash
make bootstrap
```

2) **Local cluster with kind**
```bash
make kind-up
```

3) **Deploy dev overlay with Kustomize**
```bash
fish scripts/kustomize-apply-dev.fish
kubectl -n superlab-dev get deploy,svc,hpa
```

4) **Build & push images to GHCR**
```bash
echo "$GH_TOKEN" | docker login ghcr.io -u "$GITHUB_USER" --password-stdin
make push-images
```

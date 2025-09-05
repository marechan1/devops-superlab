SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

help: ## show available targets
	@awk 'BEGIN{FS=":.*##"; printf "\nTargets:\n"} /^[a-zA-Z0-9_.-]+:.*##/{printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap: ## install dev tooling locally (pre-commit hooks)
	pre-commit install -t pre-commit -t commit-msg || true

lint: ## run multi-language linters
	pre-commit run --all-files

test: ## run unit tests where available
	./scripts/run-tests.sh

build-images: ## build all service images locally (no push)
	./scripts/build-images.sh

push-images: ## buildx + push to GHCR (requires GHCR login)
	./scripts/push-images.sh

kustomize-dev: ## apply dev overlay
	fish ./scripts/kustomize-apply-dev.fish

kustomize-stage: ## apply stage overlay
	fish ./scripts/kustomize-apply-stage.fish

kustomize-prod: ## apply prod overlay
	fish ./scripts/kustomize-apply-prod.fish

kind-up: ## create kind cluster + install addons (metrics, ingress, monitoring, logging)
	./scripts/kind-superlab-up.sh

kind-down: ## delete kind cluster
	kind delete cluster --name superlab || true

argocd-bootstrap: ## install Argo CD and app-of-apps
	kubectl apply -f ./gitops/argocd/install
	kubectl apply -f ./gitops/argocd/apps

gatekeeper-bootstrap: ## install gatekeeper + starter constraints
	kubectl apply -f ./policies/gatekeeper/install
	kubectl apply -f ./policies/gatekeeper/constraints

docs-serve: ## serve MkDocs locally
	mkdocs serve -a 0.0.0.0:8000

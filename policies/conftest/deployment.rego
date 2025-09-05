package kubernetes.admission

deny[msg] {
  input.kind.kind == "Deployment"
  some c
  c := input.spec.template.spec.containers[_]
  not startswith(c.image, "ghcr.io/")
  msg := sprintf("container %q must use ghcr.io registry (got: %q)", [c.name, c.image])
}

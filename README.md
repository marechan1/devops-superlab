# DevOps SuperLab (Bootstrap)

This repo contains:
- `scripts/self-test.fish` — quick smoke test (calls your `~/devops-status.fish` if present)
- `scripts/git-publish.fish` — push this repo to GitHub
- Fish helper functions:
  - `db-services-on` — stop lab containers, enable/start system DB services (PostgreSQL, MariaDB, Valkey/Redis)
  - `db-labs-on` — stop system DB services, start containerized DB labs (compose files in `~/labs/db`)

> You already provisioned tools and labs across DevOps, Cloud, Security, Databases, and Java/.NET/Python stacks earlier.  
> These scripts give you a clean toggle + a GitHub-ready wrapper, without re-installing everything.

## Quickstart

```bash
# run from your shell
fish ~/devops-superlab/scripts/self-test.fish
# if PASS:
fish ~/devops-superlab/scripts/git-publish.fish

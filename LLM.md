# Hanzo Runner Image

Custom GitHub Actions runner image used by all `hanzoai/*` ARC runner
scale sets on `do-sfo3-hanzo-k8s`.

Base: `ghcr.io/actions/actions-runner:latest`

Adds: `kubectl`, `doctl`, `kustomize`, `helm`, `gh`, `jq`, `git`, `make`,
`unzip`, `openssh-client`.

Published as `ghcr.io/hanzoai/runner:vX.Y.Z` on tag pushes via
the canonical `hanzoai/.github/docker-build.yml` reusable workflow.

## Why

Workflows must not curl-install ops tools per run — that's a deferred
pattern. Bake once, use everywhere. Single image, single source of
truth for runner toolchain.

## Consumers

ARC scale sets in `actions-runner-system`:

- `hanzo-build-linux-amd64`
- `hanzo-deploy-linux-amd64`
- `lux-build-linux-amd64`
- `zoo-build-linux-amd64`

Update via the values file in
`hanzo/platform/.github/runners/arc-runner-set-*-values.yaml` then
`helm upgrade`.

## arm64

Paused — DOKS does not currently offer arm64 droplets. Re-enable by
adding `linux/arm64` to `platforms:` in `.github/workflows/build.yml`
when DO ships arm64 instances.

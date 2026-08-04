# Hanzo Runner Image

Custom GitHub Actions runner image used by all `hanzoai/*` ARC runner
scale sets on `do-sfo3-hanzo-k8s`.

Base: `ghcr.io/actions/actions-runner:latest`

Adds: `kubectl`, `doctl`, `kustomize`, `helm`, `gh`, `jq`, `git`, `make`,
`unzip`, `openssh-client`, `build-essential`, `pkg-config`, and the
amd64-host → arm64-target cross toolchain (`gcc-aarch64-linux-gnu`,
`g++-aarch64-linux-gnu`, `libc6-dev-arm64-cross`) plus `musl-tools` so
workflows can cross-compile CGO binaries (BLST, etc.) without per-job
`apt-get install`.

Published as `ghcr.io/hanzoai/runner:X.Y.Z` on tag pushes via
the canonical `hanzoai/.github/docker-build.yml` reusable workflow
(`type=semver,pattern={{version}}` strips the `v` prefix).

Current: `0.1.1`. All four ARC scale sets on `do-sfo3-hanzo-k8s`
(`hanzo-build-linux-amd64`, `hanzo-deploy-linux-amd64`,
`lux-build-linux-amd64`, `zoo-build-linux-amd64`) are pinned to this tag.

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

## License

Dual-licensed `MIT OR Apache-2.0` (`LICENSE-MIT`, `LICENSE-APACHE`), at the
user's option. Relicensed from BSD-3-Clause under HIP-0137 "One License"
(`hanzoai/hips`), which standardises original Hanzo work on the dual
permissive pair. The prior BSD copyright line carries forward unchanged
into `LICENSE-MIT`.

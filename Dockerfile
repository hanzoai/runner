FROM ghcr.io/actions/actions-runner:latest

USER root

ARG KUBECTL_VERSION=v1.32.1
ARG DOCTL_VERSION=1.124.0
ARG KUSTOMIZE_VERSION=v5.5.0
ARG HELM_VERSION=v3.16.4

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates curl jq git unzip make gnupg openssh-client; \
    rm -rf /var/lib/apt/lists/*; \
    arch="$(dpkg --print-architecture)"; \
    curl -fsSLo /usr/local/bin/kubectl \
      "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${arch}/kubectl"; \
    chmod +x /usr/local/bin/kubectl; \
    curl -fsSL "https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-${arch}.tar.gz" \
      | tar -xz -C /usr/local/bin doctl; \
    curl -fsSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${arch}.tar.gz" \
      | tar -xz -C /usr/local/bin kustomize; \
    curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-${arch}.tar.gz" \
      | tar -xz --strip-components=1 -C /usr/local/bin "linux-${arch}/helm"; \
    type -p curl >/dev/null; \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg; \
    echo "deb [arch=${arch} signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list; \
    apt-get update; apt-get install -y --no-install-recommends gh; \
    rm -rf /var/lib/apt/lists/*

USER runner

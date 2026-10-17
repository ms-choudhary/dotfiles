# Local dev env, meant to run as a Docker Sandbox (sbx) template.
#   docker build -t dev .
#   docker run -it --rm dev
FROM debian:trixie

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# setup.sh base: packages, starship, kubectl + kubectl-neat, helm, tldr.
# Skips the VM-only steps (root password, virtiofs mount, root home).
COPY bin/debian.packages /tmp/debian.packages
RUN apt-get update -o APT::Update::Error-Mode=any \
  && apt-get install -y $(cat /tmp/debian.packages) \
  && rm -rf /var/lib/apt/lists/* /tmp/debian.packages

RUN arch=$(dpkg --print-architecture) \
  && curl -fsSL https://starship.rs/install.sh | sh -s -- -y \
  && curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/${arch}/kubectl" \
  && chmod +x /usr/local/bin/kubectl \
  && curl -fsSL "https://github.com/itaysk/kubectl-neat/releases/download/v2.0.4/kubectl-neat_linux_${arch}.tar.gz" \
    | tar -xz -C /usr/local/bin kubectl-neat \
  && curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash \
  && npm install -g tldr \
  && npm cache clean --force

# setup.sh golang
RUN curl -fsSL "https://go.dev/dl/go1.24.0.linux-$(dpkg --print-architecture).tar.gz" \
  | tar -xz -C /usr/local

# Docker Engine from Docker's apt repo. sbx starts dockerd itself when the
# start-docker label is set, with storage on its own volume.
RUN install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSLo /etc/apt/keyrings/docker.asc https://download.docker.com/linux/debian/gpg \
  && printf 'Types: deb\nURIs: https://download.docker.com/linux/debian\nSuites: trixie\nComponents: stable\nSigned-By: /etc/apt/keyrings/docker.asc\n' \
    > /etc/apt/sources.list.d/docker.sources \
  && apt-get update -o APT::Update::Error-Mode=any \
  && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
  && rm -rf /var/lib/apt/lists/*
LABEL com.docker.sandboxes.start-docker="true"

# Vault CLI from HashiCorp's apt repo; sbx-setup reads SSH keys from it.
RUN curl -fsSLo /etc/apt/keyrings/hashicorp.asc https://apt.releases.hashicorp.com/gpg \
  && printf 'Types: deb\nURIs: https://apt.releases.hashicorp.com\nSuites: trixie\nComponents: main\nSigned-By: /etc/apt/keyrings/hashicorp.asc\n' \
    > /etc/apt/sources.list.d/hashicorp.sources \
  && apt-get update -o APT::Update::Error-Mode=any \
  && apt-get install -y vault \
  && rm -rf /var/lib/apt/lists/*

# uid 501 matches the Mac user. Home is mounted from the Mac (sbx workspace),
# so it isn't created here. sudo skips sudoers.d files with a dot in the name.
RUN useradd -M -d /Users/mohit.choudhary/dev -u 501 -s /bin/zsh -G docker mohit.choudhary \
  && echo 'mohit.choudhary ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/mohit \
  && install -d -o mohit.choudhary /var/cache/dev
COPY bin/sbx-setup /usr/local/bin/sbx-setup
USER mohit.choudhary
ENV PATH=/Users/mohit.choudhary/dev/go/bin:/usr/local/go/bin:$PATH

# Caches stay off the Mac-mounted home; file sharing is slow. GOCACHE follows
# XDG_CACHE_HOME.
ENV XDG_CACHE_HOME=/var/cache/dev \
  GOMODCACHE=/var/cache/dev/go-mod \
  npm_config_cache=/var/cache/dev/npm

CMD ["/bin/zsh"]

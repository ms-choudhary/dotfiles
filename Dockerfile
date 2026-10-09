# Local dev env, meant to run as a Docker Sandbox (sbx) template.
#   docker build -t dev .
#   docker run -it --rm dev
FROM debian:trixie

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# setup.sh base: packages, starship, kubectl + kubectl-neat, bw, tldr.
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
  && npm install -g @bitwarden/cli tldr \
  && npm cache clean --force

# setup.sh golang
RUN curl -fsSL "https://go.dev/dl/go1.24.0.linux-$(dpkg --print-architecture).tar.gz" \
  | tar -xz -C /usr/local

RUN useradd -m -u 1000 -s /bin/zsh msc \
  && echo 'msc ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/msc

USER msc
WORKDIR /home/msc
ENV PATH=/home/msc/go/bin:/usr/local/go/bin:$PATH

# Dotfiles: same steps as `setup.sh dotfiles`, minus the git clone.
COPY --chown=msc:msc . /home/msc/dotfiles
RUN mkdir -p ~/.ssh ~/projects/src ~/.vim/autoload \
  && cp ~/dotfiles/.vim/autoload/* ~/.vim/autoload/ \
  && make -C ~/dotfiles dotfiles bins
# -u: Ex mode skips vimrc by default; -N: vimrc uses line continuations
RUN vim -Nes -u ~/.vimrc -i NONE -c 'PlugInstall --sync' -c 'qa' \
  && go clean -cache -modcache

CMD ["/bin/zsh"]

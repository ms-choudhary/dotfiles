#! /bin/bash

# uncomment to debug
# set -o xtrace
set -o errexit
set -o pipefail

install_golang_debian() {
  wget --directory-prefix /tmp https://go.dev/dl/go1.24.0.linux-arm64.tar.gz
  rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go1.24.0.linux-arm64.tar.gz
}

install_podman_ubuntu() {
  echo 'installing podman'
  sudo apt-get install -y podman
}

install_podman_fedora() {
  echo 'installing podman'
  sudo dnf install -y podman
}

install_podman_mac() {
  echo 'installing podman'
  brew install podman
}

install_vagrant_ubuntu() {
  echo 'installing vagrant'
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install vagrant
}

install_vagrant_mac() {
  echo 'installing vagrant'
  brew tap hashicorp/tap
  brew install vagrant
}

install_alacritty() {
  # snap install alacritty --classic
  # no concrete easy instructions
  # for ubuntu: go to app store & install
  # for fedora silverblue: couldn't install yet in toolbox
  # for macos: go to alacritty release & download dmg & install
  echo "unsupported: install alacritty manually"
}

install_font_mac() {
  brew tap homebrew/cask-fonts
  brew install --cask font-fira-code
}

install_asdf() {
  if ! which asdf; then
    echo 'installing asdf'
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
  fi
}

install_starship() {
  echo 'installing starship'
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"
}

install_kubectl_linux() {
  if ! which kubectl; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
  fi
}

install_asdf_plugins() {
  echo 'installing asdf plugins'
  #asdf plugin add kubectl 
  #asdf plugin add helm 
  #asdf plugin add golang 

  asdf install kubectl latest
  asdf install helm latest
  asdf install golang latest
}

install_base_ubuntu() {
  echo 'installing base'
  sudo apt-get update && apt-get install -y git  \
                          gnupg \
                          curl \
                          vim  \
                          zsh  \
                          htop \
                          tmux
}

install_base_debian() {
  echo 'installing base'

  packages_file="./debian.packages"
  if [ ! -z "$DOTFILES" ]; then
    packages_file="$DOTFILES/bin/debian.packages"
  fi
  
  apt-get update -o APT::Update::Error-Mode=any
  apt-get install -y $(cat $packages_file)

  if ! which starship; then
    install_starship
  fi

  if ! which kubectl; then
    install_kubectl_linux
  fi

  echo "install bw, tldr"
  npm install -g @bitwarden/cli
  npm install -g tldr

  echo "deleting root password"
  passwd -d root

  if ! grep -q "^share" /etc/fstab; then
    echo "adding virtiofs entry"
    echo "share /root/shared virtiofs rw,nofail 0 0" | tee -a /etc/fstab
  fi

  echo "chaging root home directory"
  sed -i "s|\/root:|\/root\/shared\/$(hostname):|g" /etc/passwd

  echo "PLEASE REBOOT YOUR SYSTEM"
}

install_base_mac() {
  if ! which brew; then
    echo 'installing homebrew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo 'installing base'
  brew update && brew install \
                      tmux \
                      watch \
                      tldr \
                      ag \
                      htop \
                      gh \
                      yq \
                      jq \
                      colordiff \
                      step

  install_font_mac

  if ! which starship; then
    install_starship
  fi
  # install firefox
  # install alacritty
  # install docker-for-mac
}

install_base_fedora() {
  echo 'installing base'
  dnf install -y \
    git \
    vim \
    zsh \
    tmux \
    watch \
    tldr \
    ag \
    htop \
    gh
}

install_ssh_keys() {
  gh auth login
  ssh-keygen -f ~/.ssh/id_github -t ed25519 -C "$(whoami)-$PLATFORM"
  gh ssh-key add ~/.ssh/id_github -t "$(whoami)-$PLATFORM"
}

install_dotfiles() {
  if [[ ! -d "${HOME}/dotfiles" ]]; then
    git clone git@github.com:ms-choudhary/dotfiles.git "${HOME}/dotfiles"
    chsh -s $(which zsh)
    mkdir -p ~/.vim/autoload && cp ~/dotfiles/.vim/autoload/* ~/.vim/autoload/
    mkdir -p ~/projects/src
  fi
  (cd "${HOME}/dotfiles" && make)
}

usage() {
	echo "Usage:"
  echo "  base                                        - Install base tools"
  echo "  ssh-keys                                    - Generate new ssh keys and add to github"
  echo "  dotfiles                                    - Clone and install dotfiles"
	echo "  asdf                                        - Install asdf and asdf-plugins for tools"
  echo "  golang                                      - Install golang"
}

if [[ $(uname) == "Darwin" ]]; then
  PLATFORM=mac
elif [[ $(uname) == "Linux" ]]; then
  . /etc/os-release
  PLATFORM=$ID
else 
  echo "ERROR: couldn't identify platform"
  exit 1
fi

echo "PLATFORM: $PLATFORM"

main() {
  local cmd=$1

  if [[ -z $cmd ]]; then
    usage
    exit 1
  fi

  if [[ $cmd == "base" ]]; then
    install_base_$PLATFORM
  elif [[ $cmd == "ssh-keys" ]]; then
    install_ssh_keys
  elif [[ $cmd == "dotfiles" ]]; then
    install_dotfiles
  elif [[ $cmd == "asdf" ]]; then
    install_asdf
    install_asdf_plugins
  elif [[ $cmd == "golang" ]]; then
    install_golang_$PLATFORM
  else
    usage
  fi
}

main "$@"

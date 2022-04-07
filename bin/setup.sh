#! /bin/bash

set -e
set -o pipefail

install_podman_apt() {
  echo 'installing podman'
  sudo apt-get install -y podman
}

install_podman_brew() {
  echo 'installing podman'
  brew install podman
}

install_vagrant_apt() {
  echo 'installing vagrant'
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install vagrant
}

install_vagrant_brew() {
  echo 'installing vagrant'
  brew tap hashicorp/tap
  brew install vagrant
}

install_alacritty() {
  # snap install alacritty --classic
  # no concrete easy instructions
  # for ubuntu: go to app store & install
  # for macos: go to alacritty release & download dmg & install
  echo "unsupported: install alacritty manually"
}

install_font_brew() {
  brew tap homebrew/cask-fonts
  brew install --cask font-fira-code
}

install_asdf() {
  echo 'installing asdf'
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
}

install_starship() {
  echo 'installing starship'
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"
}

install_base_apt() {
  echo 'installing base'
  sudo apt-get update && apt-get install -y git  \
                          vim  \
                          zsh  \
                          htop \
                          tmux
}

install_asdf_plugins() {
  echo 'installing asdf plugins'
  asdf plugin add kubectl 
  asdf plugin add helm 
  asdf plugin add oc 
  asdf plugin add golang 
  asdf plugin add gcloud
  asdf plugin add azure-cli
  asdf plugin add awscli

  asdf install kubectl 1.19.16
  asdf install helm 3.6.3
  asdf install helm 2.9.1
  asdf install oc 4.6.0
  asdf install golang 1.16.4
  asdf install gcloud latest
  asdf install azure-cli latest
  asdf install awscli latest
}

install_base_brew() {
  echo 'installing base'
  brew update && brew install \
                      tmux \
                      watch \
                      tldr \
                      ag \
                      htop
}

install_dotfiles() {
  if [[ ! -d "${HOME}/dotfiles" ]]; then
    git clone git@github.com:ms-choudhary/dotfiles.git "${HOME}/dotfiles"
    (cd "${HOME}/dotfiles" && make)
  fi
}

#if [[ $(uname) == "Linux" ]]; then
  #echo "setting up linux..."
  #install_base_apt
  #install_asdf
  #install_starship
  #install_vagrant_apt


#elif [[ $(uname) == "Darwin" ]]; then
  #echo "setting up macos..."
  #install_base_brew
  #install_asdf
  #install_starship
  #install_vagrant_brew

#else
  #echo "error: unsupported os"
  #exit 1
#fi

usage() {
	echo "Usage:"
	echo "  asdf-plugins                                - Install asdf-plugins for tools"
}

main() {
  local cmd=$1

  if [[ -z $cmd ]]; then
    usage
    exit 1
  fi

  if [[ $cmd == "asdf-plugins" ]]; then
    install_asdf_plugins
  else
    usage
  fi
}

main "$@"

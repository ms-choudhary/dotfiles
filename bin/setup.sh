#! /bin/bash

set -e
set -o pipefail

install_vagrant_apt() {
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install vagrant
}

install_vagrant_brew() {
  brew tap hashicorp/tap
  brew install vagrant
}

install_dmg() {
  echo "dmg"
}

install_alacritty() {
  snap install alacritty --classic
  # no concrete easy instructions
  # for ubuntu: go to app store & install
  # for macos: go to alacritty release & download dmg & install
  echo "unsupported: install alacritty manually"
}

install_asdf() {
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
  echo '. $HOME/.asdf/asdf.sh' >> "$HOME/.zshrc"
}

install_starship() {
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"
}

base_apt() {
  sudo apt-get install -y git  \
                          vim  \
                          zsh  \
                          tmux
}

if [[ $(uname) == "Linux" ]]; then
  echo "setting up linux..."


elif [[ $(uname) == "Darwin" ]]; then
  echo "setting up macos..."

else
  echo "error: unsupported os"
  exit 1
fi

if [[ ! -d "${HOME}/dotfiles" ]]; then
  git clone git@github.com:ms-choudhary/dotfiles.git "${HOME}/dotfiles"
  (cd "${HOME}/dotfiles" && make)
fi

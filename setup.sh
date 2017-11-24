#! /bin/bash

install_for_ubuntu() {
  sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
  sudo apt-get update
  sudo apt-get install rcm
}

install_for_mac() {
  brew tap thoughtbot/formulae
  brew install rcm
}

install_thoughtbot_rcm() {
  if type apt 2> /dev/null; then
    echo "System: debian/ubuntu"
    install_for_ubuntu
  elif type brew 2> /dev/null; then
    echo "System: mac"
    install_for_mac
  else
    echo "System not supported."
  fi
}

if ! type rcup 2> /dev/null; then
  install_thoughtbot_rcm
fi

RCRC=$HOME/dotfiles/rcrc rcup

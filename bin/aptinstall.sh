#! /bin/bash

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <arg>"
  exit 1
fi

echo "installing package: $1"

echo "$1" >> $DOTFILES/bin/debian.packages

apt install "$1"

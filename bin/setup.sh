#! /bin/bash

set -e
set -o pipefail

if [[ $(uname) == "Linux" ]]; then
  echo "setting up linux..."

elif [[ $(uname) == "Darwin" ]]; then
  echo "setting up macos..."

else
  echo "error: unsupported os"
  exit 1
fi

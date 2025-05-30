#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit

set -e

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

# No power-on when lid opened or power plugged in
sudo nvram BootPreference=%00


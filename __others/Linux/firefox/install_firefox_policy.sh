#!/usr/bin/env bash
# Firefox on Linux has no per-user policies, policies.json is system wide
# /etc/firefox/policies is read by distro packages, the snap and the Mozilla tarball/deb

if [ "$(uname)" != "Linux" ]; then
    echo "This script is for Linux only."
    exit 1
fi

# Set working dir
cd "$(dirname "$0")" || exit

sudo install -D -m 644 policies.json /etc/firefox/policies/policies.json
echo "Installed /etc/firefox/policies/policies.json, restart Firefox and check about:policies"

#!/usr/bin/env bash

# Installs the latest shellcheck, shfmt and zsh-lint into ~/.local/bin (override with BIN=...).
# Needs only curl, jq and tar, no Go: zsh-lint ships no binaries, so it is built with a
# throwaway Go toolchain (checksummed, deleted afterwards). Rerun to upgrade.

set -euo pipefail

bin=${BIN:-$HOME/.local/bin}
os=$(uname -s | tr '[:upper:]' '[:lower:]') # linux, darwin
case $(uname -m) in
x86_64) sc_arch=x86_64 go_arch=amd64 ;;
arm64 | aarch64) sc_arch=aarch64 go_arch=arm64 ;;
*) echo "unsupported arch: $(uname -m)" >&2 && exit 1 ;;
esac

tmp=$(mktemp -d)
trap 'chmod -R u+w "$tmp"; rm -rf "$tmp"' EXIT # Go's module cache is read-only
mkdir -p "$bin"

latest() { curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name; }
sha256() { if command -v sha256sum >/dev/null; then sha256sum "$1"; else shasum -a 256 "$1"; fi | cut -d' ' -f1; }

echo "shellcheck"
v=$(latest koalaman/shellcheck)
curl -fsSL "https://github.com/koalaman/shellcheck/releases/download/$v/shellcheck-$v.$os.$sc_arch.tar.xz" | tar xJ -C "$tmp"
install -m755 "$tmp/shellcheck-$v/shellcheck" "$bin/shellcheck"

echo "shfmt"
v=$(latest mvdan/sh)
curl -fsSL -o "$bin/shfmt" "https://github.com/mvdan/sh/releases/download/$v/shfmt_${v}_${os}_$go_arch"
chmod 755 "$bin/shfmt"

echo "zsh-lint (builds with a temporary Go)"
zl=$(latest z-shell/zsh-lint)
read -r file want < <(curl -fsSL 'https://go.dev/dl/?mode=json' |
    jq -r --arg os "$os" --arg arch "$go_arch" '[.[0].files[] | select(.os == $os and .arch == $arch and .kind == "archive")][0] | "\(.filename) \(.sha256)"')
curl -fsSL -o "$tmp/$file" "https://go.dev/dl/$file"
[ "$(sha256 "$tmp/$file")" = "$want" ] || { echo "go toolchain checksum mismatch" >&2 && exit 1; }
tar xzf "$tmp/$file" -C "$tmp"
GOPATH=$tmp/gopath GOCACHE=$tmp/cache GOBIN=$bin GOTOOLCHAIN=auto \
    "$tmp/go/bin/go" install "github.com/z-shell/zsh-lint/cmd/zsh-lint@$zl"

echo
"$bin/shellcheck" --version | sed -n 2p
"$bin/shfmt" --version
echo "zsh-lint $zl"
case :$PATH: in *":$bin:"*) ;; *) echo "note: $bin is not on PATH" ;; esac

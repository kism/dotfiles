# Dev

## Lint

Runs the same checks as `.github/workflows/check-*.yml`. Missing tools are skipped.

```zsh
__scripts/lint.sh   # mac and linux
pwsh __scripts/lint.ps1   # windows, PSScriptAnalyzer
```

### Linters and formatters (local)

| Tool | For | CI |
|---|---|---|
| `shellcheck` | bash/sh lint (can't read zsh) | `check-shell` |
| `shfmt` (`-i 4`, `-ln zsh` for zsh) | bash and zsh formatting | `check-shell`, `check-zsh` |
| `zsh-lint` | zsh lint, only warning/error fail | `check-zsh` |
| `zsh -n` | zsh parse | `check-zsh` |

Distro packages lag. Install or upgrade all three to the latest in `~/.local/bin` (needs only `curl`, `jq` and `tar`, no Go, with `~/.local/bin` on `PATH`):

```sh
__scripts/install-lint-tools.sh   # BIN=/other/dir to change the target
```

shellcheck and shfmt are downloaded release binaries (linux/mac, x86_64/arm64). zsh-lint ships no binaries, so the script builds it with your installed Go if it is 1.21+ (`GOTOOLCHAIN=auto` fetches the newer Go zsh-lint needs), otherwise with a checksummed, temporary Go toolchain that is deleted afterwards.

Fix formatting with `shfmt -i 4 -w <bash files>` and `shfmt -ln zsh -i 4 -w .zshrc`.

Tools it uses, all optional: `shellcheck`, `shfmt`, `zsh`, `zsh-lint`, `lua`, `actionlint`, `python3`.

## zsh

Lint with `zsh-lint .zshrc` (installed above). Zsh files are `.zshrc` plus the zsh-shebang scripts in `.local/bin`.

Startup profiling:

```zsh
for i in 1 2 3 4 5; do /usr/bin/time -p zsh -i -c exit 2>&1 | awk '/real/{print $2}'; done

D=$(mktemp -d); { echo 'zmodload zsh/zprof'; cat ~/.zshrc; echo 'zprof'; } > $D/.zshrc
ZDOTDIR=$D zsh -i -c exit | head -25
```

## Ghostty terminfo

Update on a machine with Ghostty (mac `tic` writes hex dirs like `78/`, so copy into the linux layout):

```sh
infocmp -x xterm-ghostty > /tmp/g.src && rm -rf /tmp/ti && tic -x -o /tmp/ti /tmp/g.src \
  && f=$(find /tmp/ti -name xterm-ghostty) && cp "$f" .terminfo/x/xterm-ghostty && cp "$f" .terminfo/g/ghostty
```

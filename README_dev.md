# Dev

## Lint

Runs the same checks as `.github/workflows/check-*.yml`. Missing tools are skipped.

```zsh
__scripts/lint.sh   # mac and linux
pwsh __scripts/lint.ps1   # windows, PSScriptAnalyzer
```

Tools it uses, all optional: `shellcheck`, `shfmt`, `zsh`, `lua`, `actionlint`, `python3`.

## zsh

```zsh
zi light z-shell/zsh-lint
zsh-lint .zshrc
code --diff .zshrc .zshrc_gen
```

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

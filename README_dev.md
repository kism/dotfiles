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

#!/usr/bin/env bash

# Local version of .github/workflows/check-*.yml, for mac and linux.
# A missing tool is skipped rather than failed, CI is the real gate.
# Only tracked files are checked, same as CI.

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

rc=0
h() { printf '\n\033[0;34m==> %s\033[0m\n' "$1"; }
skip() { printf '\033[0;33mskipped, %s not installed\033[0m\n' "$1"; }

check() { # check <label> <command...>
    label=$1
    shift
    if "$@"; then
        echo "ok $label"
    else
        printf '\033[0;31mFAIL %s\033[0m\n' "$label"
        rc=1
    fi
}

# No spaces in any of these paths, so word splitting is fine and intended
shell_files=$(git ls-files '*.sh' '.bash*' .local/bin)
shellcheck_files=$(echo "$shell_files" | grep -v zzz_mount_nfs_macos) # not valid sh

h "shellcheck"
if type shellcheck >/dev/null 2>&1; then
    # shellcheck disable=SC2086
    check shellcheck shellcheck -e SC1091 $shellcheck_files
else
    skip shellcheck
fi

h "shfmt"
if type shfmt >/dev/null 2>&1; then
    # shellcheck disable=SC2086
    check shfmt shfmt -d -i 4 $shell_files
else
    skip shfmt
fi

h "zsh -n"
if type zsh >/dev/null 2>&1; then
    check .zshrc zsh -n .zshrc
else
    skip zsh
fi

h "toml"
for f in $(git ls-files '*.toml'); do
    check "$f" python3 -c "import tomllib,sys; tomllib.load(open(sys.argv[1],'rb'))" "$f"
done

h "lua"
lua_bin=$(command -v lua5.4 || command -v lua || true)
if [ -n "$lua_bin" ]; then
    for f in $(git ls-files '*.lua'); do
        check "$f" "$lua_bin" -e "assert(loadfile('$f'))" # compile only, never runs it
    done
else
    skip lua
fi

h "plists and mobileconfigs"
while IFS= read -r -d '' f; do
    check "$f" python3 -c "import plistlib,sys; plistlib.load(open(sys.argv[1],'rb'))" "$f"
done < <(git ls-files -z '*.plist' '*.mobileconfig')

h "actionlint"
if type actionlint >/dev/null 2>&1; then
    check actionlint actionlint
else
    skip actionlint
fi

h "powershell"
echo "run '__scripts/lint.ps1' with pwsh for the .ps1 files"

if [ "$rc" -eq 0 ]; then
    printf '\n\033[0;32mAll checks passed\033[0m\n'
else
    printf '\n\033[0;31mSome checks failed\033[0m\n'
fi
exit "$rc"

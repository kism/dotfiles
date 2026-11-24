#!/usr/bin/env bash
# Exclude directories from Time Machine.
#
#   ./timemachine_exclude.sh              # apply the lists below
#   ./timemachine_exclude.sh --dry-run    # show what would be excluded
#   ./timemachine_exclude.sh PATH...      # also exclude these paths
#
# Uses sticky exclusions (tmutil addexclusion): the exclusion is stored on the item
# itself, follows it if moved, and needs no sudo. Excluding only stops future
# backups; existing copies age out as old backups are thinned.

if [ "$(uname)" != "Darwin" ]; then
    echo "This script is for MacOS only."
    exit 1
fi

DRY_RUN=0
extra=()
for arg in "$@"; do
    case "$arg" in
    -n | --dry-run) DRY_RUN=1 ;;
    *) extra+=("$arg") ;;
    esac
done

# Fixed paths to exclude
paths=(
    "$HOME/Downloads"
    "$HOME/Library/Caches"
    # Application Support: only re-downloadable / synced stuff. Keep Signal, PrismLauncher,
    # factorio, RetroArch, AddressBook etc. backed up (local-only saves/history).
    "$HOME/Library/Application Support/Claude"
    "$HOME/Library/Application Support/Steam"
    "$HOME/Library/Application Support/discord"
    "$HOME/Library/Application Support/Google"
    "$HOME/Library/Application Support/Wineskin"
    "$HOME/Library/Application Support/Code"
    "$HOME/Library/Application Support/Firefox"
    "$HOME/Library/Application Support/com.raycast.macos"
    "$HOME/Library/Application Support/com.apple.wallpaper"
    "$HOME/Library/Application Support/Spotify"
    "$HOME/Library/Application Support/Caches"
    "$HOME/Library/Application Support/aws-cloudformation-languageserver"
    "$HOME/Library/Application Support/CrowdedStreet"
    "$HOME/Library/Application Support/JDownloader 2"
    "$HOME/Library/Application Support/ComfyUI"
    "$HOME/Library/Containers/com.docker.docker"
    "$HOME/Library/Developer/Xcode/DerivedData"
    "$HOME/Library/Developer/CoreSimulator"
    "$HOME/.cache"
    "$HOME/.npm"
    "$HOME/.pnpm-store"
    "$HOME/Library/pnpm/store"
    "$HOME/.local/share/pnpm"
    "$HOME/.cargo/registry"
    "$HOME/.rustup"
    "$HOME/.gradle/caches"
    "$HOME/.ollama/models"
    "$HOME/.local/share/uv"
    "$HOME/go/pkg/mod"
    "$HOME/.Trash"
    "$HOME/UTM"
    "$HOME/VMs"
    "$HOME/qemu"
    "$HOME/ROMs"
    "$HOME/.vscode"
    "$HOME/Library/Containers/com.utmapp.UTM/Data/Documents" # UTM default VM location
    "${extra[@]}"
)

# Paths not owned by you: excluded by fixed path (tmutil addexclusion -p), needs sudo
sudo_paths=(
    /Users/qbtuser/Documents
    /Users/qbtuser/Movies
    /Applications # reinstall with install_brew_gui.sh / install_appstore.sh
    /opt/homebrew # reinstall with install_brew_cli.sh
)

# Directory names to exclude wherever they appear under search_roots (regenerable stuff)
dir_names=(
    node_modules
    .venv
    venv
    .tox
    .mypy_cache
    .pytest_cache
    .ruff_cache
    .next
    target # rust
)
search_roots=(
    "$HOME/projects"
    "$HOME/Documents"
)

exclude() {
    local p="$1"
    [ -e "$p" ] || return
    if tmutil isexcluded "$p" | grep -q '^\[Excluded\]'; then
        echo "already  $p"
    elif [ "$DRY_RUN" = 1 ]; then
        echo "would    $p ($(du -sh "$p" 2>/dev/null | cut -f1))"
    else
        tmutil addexclusion "$p" && echo "excluded $p"
    fi
}

for p in "${paths[@]}"; do
    exclude "$p"
done

for p in "${sudo_paths[@]}"; do
    if ! sudo test -e "$p"; then
        continue
    elif sudo tmutil isexcluded "$p" | grep -q '^\[Excluded\]'; then
        echo "already  $p"
    elif [ "$DRY_RUN" = 1 ]; then
        echo "would    $p ($(sudo du -sh "$p" 2>/dev/null | cut -f1), fixed path)"
    else
        sudo tmutil addexclusion -p "$p" && echo "excluded $p (fixed path)"
    fi
done

find_args=()
for name in "${dir_names[@]}"; do
    find_args+=(-name "$name" -o)
done
unset 'find_args[${#find_args[@]}-1]'

for root in "${search_roots[@]}"; do
    [ -d "$root" ] || continue
    # -prune stops descending into matches (no node_modules inside node_modules)
    while IFS= read -r -d '' p; do
        exclude "$p"
    done < <(find "$root" -type d \( "${find_args[@]}" \) -prune -print0 2>/dev/null)
done

echo
echo "Done. Check with: tmutil isexcluded <path>   Remove with: tmutil removeexclusion <path>"

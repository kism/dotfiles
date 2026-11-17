#!/usr/bin/env bash
# Claude Code statusline: dir | repo:branch | model | ctx % | session meter + reset | mercury
in=$(cat)
[[ $LANG$LC_ALL == *UTF-8* ]] || export LC_ALL=C.UTF-8 # so ${#var} counts glyphs, not bytes
dir=$(jq -r '.workspace.current_dir // .cwd // ""' <<<"$in")
model=$(jq -r '.model.display_name // empty' <<<"$in")
effort=$(jq -r '.effort.level // empty' <<<"$in")
mid=$(jq -r '.model.id // empty' <<<"$in")
pct=$(jq -r '.context_window.used_percentage // empty' <<<"$in")
ses=$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<<"$in")
rst=$(jq -r '.rate_limits.five_hour.resets_at // empty' <<<"$in") # epoch seconds

R=$'\e[0m' G=$'\e[32m' Y=$'\e[33m' O=$'\e[38;5;208m' X=$'\e[31m' # green, yellow, orange, red

heat() { # usage % -> colour: <50 green, <75 yellow, <90 orange, else red
    if (($1 < 50)); then printf %s "$G"; elif (($1 < 75)); then printf %s "$Y"; elif (($1 < 90)); then printf %s "$O"; else printf %s "$X"; fi
}

out="${dir/#"$HOME"/\~}"
if top=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null); then
    out+=" | ${top##*/}:$(git -C "$dir" branch --show-current 2>/dev/null)"
fi

# model, coloured by weight: haiku green, sonnet yellow, opus orange, fable/mythos red
if [ -n "$model" ]; then
    case "$mid$model" in
    *[Hh]aiku*) c=$G ;;
    *[Ss]onnet*) c=$Y ;;
    *[Oo]pus*) c=$O ;;
    *) c=$X ;;
    esac
    out+=" | $c$model$R${effort:+ $'\e[2m'$effort$R}"
fi

if [ -n "$pct" ]; then
    p=${pct%.*}
    out+=" | $(heat "$p")ctx $p%$R"
fi

if [ -n "$ses" ]; then # "current session" = 5h rate limit window, as in /usage
    p=${ses%.*}
    n=$((p / 10))
    ((n > 10)) && n=10
    c=$(heat "$p")
    f='██████████' e='░░░░░░░░░░'
    out+=" | $c${f:0:n}${e:0:10-n} $p%$R"
    if [ -n "$rst" ]; then # GNU date, else BSD/mac
        t=$(date -d "@$rst" +%H:%M 2>/dev/null || date -r "$rst" +%H:%M 2>/dev/null) && out+=" resets $t"
    fi
fi

# mercury status from the cache the zsh banner keeps fresh (.zshrc get_mercury_retrograde); blank if absent
mf=~/.config/mercuryretrograde
if [ -s "$mf" ]; then
    if grep -q false "$mf"; then out+=" | ☿ ${G}Prograde$R"; else out+=" | ☿ ${X}Retrograde$R"; fi
fi

# enabled plugins (user + project settings); names in full if they fit COLUMNS, else a count
cfg=()
for f in ~/.claude/settings.json "$dir/.claude/settings.json" "$dir/.claude/settings.local.json"; do [ -f "$f" ] && cfg+=("$f"); done
((${#cfg[@]})) && mapfile -t plugins < <(jq -rs '[.[].enabledPlugins // {} | to_entries[]] | from_entries | to_entries[] | select(.value) | .key | sub("@.*"; "")' "${cfg[@]}" 2>/dev/null)
if ((${#plugins[@]})); then
    list=$(
        IFS=,
        printf '%s' "${plugins[*]}" | sed 's/,/, /g'
    )
    # shellcheck disable=SC2001 # bash can't strip escape sequences without extglob
    plain=$(sed $'s/\e\\[[0-9;]*m//g' <<<"$out") # strip colours to measure
    if [ -z "$COLUMNS" ] || ((${#plain} + ${#list} + 3 <= COLUMNS - 4)); then
        out+=" | $list"
    else
        out+=" | ${#plugins[@]} plugins"
    fi
fi

printf '%s' "$out"

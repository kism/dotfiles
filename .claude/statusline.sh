#!/usr/bin/env bash
# Claude Code statusline: dir | repo:branch | model | ctx % | session meter + reset | plugins | penguins | mercury | moon | inuktitut place + temp | ANT stock
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

# Penguins: current game if live, else the last finished one (NHL api-web, 3 min cache); "-" on failure
nc=~/.cache/claude-statusline-pit
if [ -z "$(find "$nc" -mmin -3 2>/dev/null)" ]; then
    g=$(curl -sLm2 "https://api-web.nhle.com/v1/club-schedule-season/PIT/now" | jq -r '[.games[] | select(.gameState != "FUT" and .gameState != "PRE")] | last | (if .awayTeam.abbrev == "PIT" then [.awayTeam, .homeTeam] else [.homeTeam, .awayTeam] end) as [$p, $o] | "PIT \($p.score)-\($o.score) \($o.abbrev)" + (if .gameState | IN("LIVE", "CRIT") then " live" else "" end)' 2>/dev/null)
    mkdir -p "${nc%/*}"
    echo "${g:--}" >"$nc"
fi
out+=" | $(<"$nc")"

# mercury status from the cache the zsh banner keeps fresh (.zshrc get_mercury_retrograde); blank if absent
mf=~/.config/mercuryretrograde
if [ -s "$mf" ]; then
    if grep -q false "$mf"; then out+=" | ☿ ${G}Prograde$R"; else out+=" | ☿ ${X}Retrograde$R"; fi
fi

# moon phase, computed locally: seconds since a known new moon (2000-01-06 18:14 UTC) mod the synodic month, in eighths
# ponytail: mean synodic month, accurate to about a day
m=("🌑 New" "🌒 Waxing Crescent" "🌓 First Quarter" "🌔 Waxing Gibbous" "🌕 Full" "🌖 Waning Gibbous" "🌗 Last Quarter" "🌘 Waning Crescent")
out+=" | ${m[$((((($(date +%s) - 947182440) % 2551443) * 8 + 1275721) / 2551443 % 8))]}"

# random Canadian place in Inuktitut syllabics + temp (Open-Meteo, no key); place and weather cached 1h
# entries: name lat lon (approximate for regions)
places=(
    "ᐃᖃᓗᐃᑦ 63.75 -68.52" "ᓄᓇᕗᑦ 66 -90" "ᓄᓇᕕᒃ 58 -72" "ᓄᓇᑦᓯᐊᖅ 56.5 -61.7"
    "ᑭᕕᖅᑖᓗᒃ 63 -93" "ᑭᑦᑭᑕᓂ 68.5 -100" "ᑰᔾᔪᐊᖅ 58.1 -68.4" "ᑲᖏᖅᓕᓂᖅ 62.81 -92.09"
    "ᐃᖃᓗᒃᑑᑦᑎᐊᖅ 69.12 -105.06" "ᐸᖕᓂᖅᑑᖅ 66.15 -65.71" "ᑭᙵᐃᑦ 64.23 -76.54" "ᐃᒡᓗᓕᒃ 69.38 -81.8"
    "ᖃᐅᓱᐃᑦᑐᖅ 74.7 -94.83" "ᐊᕐᕕᐊᑦ 61.11 -94.06" "ᖃᒪᓂᑐᐊᖅ 64.32 -96.02" "ᐃᓄᕕᒃ 68.36 -133.72"
    "ᒥᑦᑎᒪᑕᓕᒃ 72.7 -77.96"
)
pc=~/.cache/claude-statusline-place
if [ -z "$(find "$pc" -mmin -60 2>/dev/null)" ]; then
    read -r nm la lo <<<"${places[RANDOM % ${#places[@]}]}"
    t=$(curl -sm2 "https://api.open-meteo.com/v1/forecast?latitude=$la&longitude=$lo&current=temperature_2m" | jq -r '.current.temperature_2m // empty' 2>/dev/null)
    mkdir -p "${pc%/*}"
    echo "$nm${t:+ $(printf '%.0f' "$t")°C}" >"$pc"
fi
[ -s "$pc" ] && out+=" | $(<"$pc")"

# Anthropic stock (Yahoo chart API, 15 min cache); "-" while unlisted or on any failure
sc=~/.cache/claude-statusline-ant
if [ -z "$(find "$sc" -mmin -15 2>/dev/null)" ]; then
    p=$(curl -sm2 -A 'Mozilla/5.0' "https://query1.finance.yahoo.com/v8/finance/chart/ANT?interval=1d&range=1d" | jq -r '.chart.result[0].meta.regularMarketPrice // empty' 2>/dev/null)
    mkdir -p "${sc%/*}"
    { [ -n "$p" ] && printf '$%.2f\n' "$p" || echo -; } >"$sc"
fi
out+=" | ANT $(<"$sc")"

printf '%s' "$out"

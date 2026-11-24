#!/usr/bin/env python3
"""Claude Code statusline, stdlib only.

repo:branch (or dir) | model | ctx % | session meter + reset | plugins | penguins
| mercury | inuktitut place + temp | ANT stock
"""

import json
import os
import random
import re
import subprocess
import sys
import time
import urllib.request
from datetime import datetime
from pathlib import Path

R, G, Y, O, X, DIM = (
    "\033[0m",
    "\033[32m",
    "\033[33m",
    "\033[38;5;208m",
    "\033[31m",
    "\033[2m",
)
HOME = Path.home()
CACHE = HOME / ".cache"

# random Canadian place in Inuktitut syllabics: name, lat, lon (approximate for regions)
PLACES = [
    ("ᐃᖃᓗᐃᑦ", 63.75, -68.52), ("ᓄᓇᕗᑦ", 66, -90), ("ᓄᓇᕕᒃ", 58, -72), ("ᓄᓇᑦᓯᐊᖅ", 56.5, -61.7),
    ("ᑭᕕᖅᑖᓗᒃ", 63, -93), ("ᑭᑦᑭᑕᓂ", 68.5, -100), ("ᑰᔾᔪᐊᖅ", 58.1, -68.4), ("ᑲᖏᖅᓕᓂᖅ", 62.81, -92.09),
    ("ᐃᖃᓗᒃᑑᑦᑎᐊᖅ", 69.12, -105.06), ("ᐸᖕᓂᖅᑑᖅ", 66.15, -65.71), ("ᑭᙵᐃᑦ", 64.23, -76.54), ("ᐃᒡᓗᓕᒃ", 69.38, -81.8),
    ("ᖃᐅᓱᐃᑦᑐᖅ", 74.7, -94.83), ("ᐊᕐᕕᐊᑦ", 61.11, -94.06), ("ᖃᒪᓂᑐᐊᖅ", 64.32, -96.02), ("ᐃᓄᕕᒃ", 68.36, -133.72),
    ("ᒥᑦᑎᒪᑕᓕᒃ", 72.7, -77.96),
]  # fmt: skip


def heat(p):
    """Usage % -> colour: <50 green, <75 yellow, <90 orange, else red."""
    return G if p < 50 else Y if p < 75 else O if p < 90 else X


def get_json(url):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=2) as r:
        return json.load(r)


def cached(name, max_age_min, fetch):
    """Return the cache file's text, refreshing it with fetch() when stale; "-" on failure."""
    f = CACHE / name
    try:
        fresh = time.time() - f.stat().st_mtime < max_age_min * 60
    except OSError:
        fresh = False
    if not fresh:
        try:
            text = fetch() or "-"
        except Exception:  # network, json, missing key: all just mean "-"
            text = "-"
        f.parent.mkdir(parents=True, exist_ok=True)
        f.write_text(text + "\n")
    return f.read_text().strip()


def git(d, *args):
    r = subprocess.run(["git", "-C", d, *args], capture_output=True, text=True)
    return r.stdout.strip() if r.returncode == 0 else None


def penguins():
    """Current game if live, else the last finished one."""
    data = get_json("https://api-web.nhle.com/v1/club-schedule-season/PIT/now")
    g = [g for g in data["games"] if g["gameState"] not in ("FUT", "PRE")][-1]
    p, o = (
        (g["awayTeam"], g["homeTeam"])
        if g["awayTeam"]["abbrev"] == "PIT"
        else (g["homeTeam"], g["awayTeam"])
    )
    s = f"PIT {p['score']}-{o['score']} {o['abbrev']}"
    return f"{s} {X}LIVE{R}" if g["gameState"] in ("LIVE", "CRIT") else s


def place():
    nm, la, lo = random.choice(PLACES)
    try:
        t = get_json(
            f"https://api.open-meteo.com/v1/forecast?latitude={la}&longitude={lo}&current=temperature_2m"
        )
        return f"{nm} {round(t['current']['temperature_2m'])}°C"
    except Exception:
        return nm


def ant():
    data = get_json(
        "https://query1.finance.yahoo.com/v8/finance/chart/ANT?interval=1d&range=1d"
    )
    # vs previous close: day in progress while trading, last session once closed
    m = data["chart"]["result"][0]["meta"]
    p, prev = m["regularMarketPrice"], m["chartPreviousClose"]
    d = p - prev
    return f"${p:.2f} {G if d >= 0 else X}{d:+.2f} ({d / prev:+.2%}){R}"


def plugins(d):
    """Enabled plugins from user + project settings, later files override earlier."""
    merged = {}
    for f in (
        HOME / ".claude/settings.json",
        Path(d, ".claude/settings.json"),
        Path(d, ".claude/settings.local.json"),
    ):
        try:
            merged.update(json.loads(f.read_text()).get("enabledPlugins") or {})
        except (OSError, ValueError):
            pass
    return [k.split("@")[0] for k, v in merged.items() if v]


def main():
    inp = json.load(sys.stdin)
    d = (inp.get("workspace") or {}).get("current_dir") or inp.get("cwd") or ""
    model = inp.get("model") or {}
    ctx = (inp.get("context_window") or {}).get("used_percentage")
    five = (inp.get("rate_limits") or {}).get("five_hour") or {}

    # repo:branch inside a git repo, else the dir
    if d and (top := git(d, "rev-parse", "--show-toplevel")):
        out = [f"{Path(top).name}:{git(d, 'branch', '--show-current') or ''}"]
    else:
        out = [d.replace(str(HOME), "~", 1) if d.startswith(str(HOME)) else d]

    # model, coloured by weight: haiku green, sonnet yellow, opus orange, fable/mythos red
    if name := model.get("display_name"):
        w = (model.get("id", "") + name).lower()
        c = G if "haiku" in w else Y if "sonnet" in w else O if "opus" in w else X
        effort = (inp.get("effort") or {}).get("level")
        # ponytail: unknown levels fall back to the word
        effort = {"low": "▁", "medium": "▃", "high": "▅", "xhigh": "▇", "max": "█"}.get(effort, effort)
        out.append(f"{c}{name}{R}" + (f" {DIM}{effort}{R}" if effort else ""))

    if ctx is not None:
        out.append(f"{heat(int(ctx))}ctx {int(ctx)}%{R}")

    # "current session" = 5h rate limit window, as in /usage
    if (ses := five.get("used_percentage")) is not None:
        p = int(ses)
        n = min(p // 10, 10)
        s = f"{heat(p)}{'█' * n}{'░' * (10 - n)} {p}%{R}"
        if rst := five.get("resets_at"):
            s += f" ↻ {datetime.fromtimestamp(rst):%H:%M}"
        out.append(s)

    # plugin names in full if they fit COLUMNS, else a count
    if pl := plugins(d):
        names = ", ".join(pl)
        width = len(re.sub(r"\033\[[0-9;]*m", "", " | ".join(out)))
        cols = os.environ.get("COLUMNS")
        out.append(
            names
            if not cols or width + len(names) + 3 <= int(cols) - 4
            else f"{len(pl)} plugins"
        )

    # refresh every 30s while the last fetch showed a live game, else every 3 min
    pit = CACHE / "claude-statusline-pit"
    live = pit.exists() and "LIVE" in pit.read_text()
    out.append(cached(pit.name, 0.5 if live else 3, penguins))

    # mercury status from the cache the zsh banner keeps fresh (.zshrc get_mercury_retrograde)
    try:
        m = (HOME / ".config/mercuryretrograde").read_text()
        if m:
            out.append(f"☿ {G}Prograde{R}" if "false" in m else f"☿ {X}Retrograde{R}")
    except OSError:
        pass

    out.append(cached("claude-statusline-place", 60, place))
    out.append("ANT " + cached("claude-statusline-ant", 15, ant))

    print(" | ".join(out), end="")


if __name__ == "__main__":
    main()

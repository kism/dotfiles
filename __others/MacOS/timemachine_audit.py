#!/usr/bin/env python3
"""Audit Time Machine backups to find out what is using the space.

Needs sudo, Full Disk Access for your terminal (System Settings > Privacy &
Security), and the backup sparsebundle mounted: Finder > Go > Connect to Server >
smb://<nas>/TimeMachine, double-click the .sparsebundle (or just let a backup run).

Each finished backup is an APFS snapshot inside the sparsebundle volume; this
script mounts the snapshots it needs read-only and unmounts them afterwards.

    sudo ./timemachine_audit.py                      # summary, exclusions, snapshot list
    sudo ./timemachine_audit.py --large 1G           # files >= 1G across ~10 sampled snapshots
    sudo ./timemachine_audit.py --large 500M --all --path Users/kism
    sudo ./timemachine_audit.py --du --path Users    # biggest dirs in latest snapshot
    sudo ./timemachine_audit.py --churn              # what changed between the last two backups
    sudo ./timemachine_audit.py --unique             # space freed by deleting each backup (slow)
"""

import argparse
import glob
import os
import plistlib
import re
import shutil
import subprocess
import sys
import tempfile
from collections import defaultdict
from contextlib import ExitStack, contextmanager

UNITS = {"": 1, "B": 1, "K": 1024, "M": 1024**2, "G": 1024**3, "T": 1024**4, "P": 1024**5}
COMPARE_RE = re.compile(r"^([+!-])\s+([\d.]+)\s*([KMGTP]?)B?\s+(/.*)$")
SNAP_RE = re.compile(r"com\.apple\.TimeMachine\.(\d{4}-\d{2}-\d{2}-\d{6})\.backup")


def human(n: float) -> str:
    for unit in ("B", "K", "M", "G", "T"):
        if abs(n) < 1024 or unit == "T":
            return f"{n:6.1f}{unit}"
        n /= 1024
    return str(n)


def parse_size(s: str) -> int:
    m = re.fullmatch(r"([\d.]+)\s*([KMGTP]?)B?", s.strip().upper())
    if not m:
        raise argparse.ArgumentTypeError(f"bad size: {s}")
    return int(float(m[1]) * UNITS[m[2]])


def run(cmd: list[str], timeout: int | None = None) -> str:
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return ""
    return r.stdout + (r.stderr if r.returncode else "")


def header(title: str) -> None:
    print(f"\n=== {title} " + "=" * max(0, 70 - len(title)), flush=True)


def backup_volume() -> tuple[str, str] | None:
    """(device, mountpoint) of the mounted Time Machine backup volume."""
    for line in run(["mount"]).splitlines():
        m = re.match(r"^(/dev/disk\S+) on (/Volumes/Backups of .+?) \(apfs", line)
        if m:
            return m[1], m[2]
    return None


def list_snapshots(device: str) -> list[str]:
    """Snapshot names, oldest first."""
    out = run(["diskutil", "apfs", "listSnapshots", device])
    return sorted(set(SNAP_RE.findall(out)))


@contextmanager
def mounted_snapshot(device: str, stamp: str):
    """Mount a backup snapshot read-only; yields the source volume's data root inside it."""
    mp = tempfile.mkdtemp(prefix=f"tm-{stamp}-")
    snap = f"com.apple.TimeMachine.{stamp}.backup"
    r = subprocess.run(["mount_apfs", "-o", "ro,nobrowse", "-s", snap, device, mp], capture_output=True, text=True)
    if r.returncode:
        os.rmdir(mp)
        raise RuntimeError(f"mount {snap}: {r.stderr.strip()}")
    try:
        # Layout: <mp>/<stamp>.backup/<Volume Name - Data>/...
        inner = glob.glob(os.path.join(mp, "*.backup")) or [mp]
        vols = [d for d in glob.glob(os.path.join(inner[0], "*")) if os.path.isdir(d)]
        data = [d for d in vols if d.endswith(" - Data")]
        yield (data or vols or [inner[0]])[0]
    finally:
        subprocess.run(["umount", mp], capture_output=True)
        try:
            os.rmdir(mp)
        except OSError:
            pass


def section_destination(vol: tuple[str, str] | None) -> None:
    header("Destination")
    print(run(["tmutil", "destinationinfo"]).strip())
    share = [line.split(" on ", 1)[1].split(" (smbfs")[0] for line in run(["mount"]).splitlines() if "(smbfs" in line]
    for mp in share:
        u = shutil.disk_usage(mp)
        print(f"NAS share {mp}: used {human(u.used).strip()} / {human(u.total).strip()}, free {human(u.free).strip()}")
        for sb in glob.glob(os.path.join(mp, "*.sparsebundle")):
            size = run(["du", "-sk", sb]).split("\t")[0]
            if size.isdigit():
                print(f"  {os.path.basename(sb)}: {human(int(size) * 1024).strip()}")
    if vol:
        u = shutil.disk_usage(vol[1])
        print(f"Backup volume {vol[1]} ({vol[0]}): used {human(u.used).strip()}, ceiling {human(u.total).strip()}")
        if u.total > sum(shutil.disk_usage(m).total for m in share or ["/"]):
            print("  note: ceiling is bigger than the NAS, so Time Machine only prunes when the NAS is full.")
            print("        Cap it with: sudo tmutil setquota <destination ID> <GB>")
    stale = [d for d in glob.glob("/Volumes/Backups of *") if not vol or d != vol[1]]
    if stale:
        print("Leftover mountpoint dirs on the boot disk (not mounted volumes):")
        for d in stale:
            print(f"  {d}")


def section_exclusions() -> None:
    header("Current exclusions")
    prefs = "/Library/Preferences/com.apple.TimeMachine.plist"
    try:
        with open(prefs, "rb") as f:
            p = plistlib.load(f)
        for key in ("SkipPaths", "ExcludeByPath"):
            for path in p.get(key, []):
                print(f"  [{key}] {path}")
        print(f"  SkipSystemFiles: {p.get('SkipSystemFiles', False)}")
    except (OSError, plistlib.InvalidFileException) as e:
        print(f"  can't read {prefs}: {e}")
    sticky = run(["mdfind", "com_apple_backup_excludeItem = 'com.apple.backupd'"], timeout=60).splitlines()
    print(f"  Sticky (tmutil addexclusion) items: {len(sticky)}  (list: mdfind \"com_apple_backup_excludeItem = 'com.apple.backupd'\")")


def section_snapshots(snaps: list[str]) -> None:
    header(f"Backups ({len(snaps)})")
    if snaps:
        print(f"  oldest {snaps[0]}, newest {snaps[-1]}")


def sample(snaps: list[str], n: int) -> list[str]:
    if n <= 0 or len(snaps) <= n:
        return snaps
    idx = {round(i * (len(snaps) - 1) / (n - 1)) for i in range(n)}
    return [snaps[i] for i in sorted(idx)]


def walk_large(root: str, sub: str, min_size: int):
    """Yield (relpath, allocated_bytes) for files >= min_size."""
    start = os.path.join(root, sub)
    stack = [start]
    while stack:
        d = stack.pop()
        try:
            with os.scandir(d) as it:
                for e in it:
                    try:
                        if e.is_dir(follow_symlinks=False):
                            stack.append(e.path)
                        elif e.is_file(follow_symlinks=False):
                            st = e.stat(follow_symlinks=False)
                            size = max(st.st_size, st.st_blocks * 512) if st.st_blocks else st.st_size
                            if size >= min_size:
                                yield os.path.relpath(e.path, root), size
                    except OSError:
                        pass
        except OSError:
            pass


def section_large(device: str, snaps: list[str], picked: list[str], sub: str, min_size: int, top: int) -> None:
    header(f"Files >= {human(min_size).strip()} in {len(picked)}/{len(snaps)} backups (/{sub})")
    seen: dict[str, dict] = {}
    for stamp in picked:
        print(f"  scanning {stamp} ...", file=sys.stderr, flush=True)
        try:
            with mounted_snapshot(device, stamp) as root:
                for path, size in walk_large(root, sub, min_size):
                    rec = seen.setdefault(path, {"max": 0, "first": stamp, "last": stamp, "n": 0})
                    rec["max"] = max(rec["max"], size)
                    rec["last"] = stamp
                    rec["n"] += 1
        except RuntimeError as e:
            print(f"  skip: {e}")
    latest = picked[-1]
    rows = sorted(seen.items(), key=lambda kv: kv[1]["max"], reverse=True)
    gone = sum(r["max"] for _, r in rows if r["last"] != latest)
    print(f"  {len(rows)} files, {human(sum(r['max'] for _, r in rows)).strip()} total "
          f"({human(gone).strip()} of it no longer in the latest backup)")
    print(f"  {'size':>7}  {'seen':>5}  {'first':17}  {'last':17}  path   (* = deleted since)")
    for path, r in rows[:top]:
        mark = "*" if r["last"] != latest else " "
        print(f"  {human(r['max'])}  {r['n']:>2}/{len(picked):<2}  {r['first']}  {r['last']} {mark}/{path}")


def section_du(device: str, stamp: str, sub: str, depth: int, top: int) -> None:
    with mounted_snapshot(device, stamp) as root:
        header(f"Largest dirs in {stamp}: /{sub} (depth {depth})")
        out = run(["du", "-k", "-x", "-d", str(depth), os.path.join(root, sub)])
        rows = []
        for line in out.splitlines():
            size, _, path = line.partition("\t")
            if size.isdigit():
                rows.append((int(size) * 1024, os.path.relpath(path, root)))
        for size, path in sorted(rows, reverse=True)[:top]:
            print(f"  {human(size)}  /{path}")


def section_churn(device: str, older: str, newer: str, depth: int, top: int) -> None:
    header(f"Churn {older} -> {newer}")
    with ExitStack() as stack:
        a = stack.enter_context(mounted_snapshot(device, older))
        b = stack.enter_context(mounted_snapshot(device, newer))
        out = run(["tmutil", "compare", "-s", a, b])
    by_dir: dict[str, int] = defaultdict(int)
    total = parsed = 0
    for line in out.splitlines():
        m = COMPARE_RE.match(line.strip())
        if not m:
            continue
        parsed += 1
        op, num, unit, path = m.groups()
        if op == "-":
            continue
        size = int(float(num) * UNITS[unit])
        total += size
        for prefix in (b, a):
            if path.startswith(prefix):
                path = path[len(prefix):]
                break
        by_dir["/" + "/".join(path.strip("/").split("/")[:depth])] += size
    if not parsed:
        print("  (couldn't parse tmutil compare output; raw tail below)")
        print("\n".join(out.splitlines()[-15:]))
        return
    print(f"  added+changed: {human(total).strip()}")
    for path, size in sorted(by_dir.items(), key=lambda kv: kv[1], reverse=True)[:top]:
        print(f"  {human(size)}  {path}")


def section_unique(snaps: list[str]) -> None:
    header("Unique size per backup (space freed if deleted)")
    paths = [l.strip() for l in run(["tmutil", "listbackups"]).splitlines() if l.strip().endswith(".backup")]
    for p in paths:
        out = run(["tmutil", "uniquesize", p]).strip().splitlines()
        print("  " + (out[-1] if out else f"?  {p}"), flush=True)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--large", type=parse_size, metavar="SIZE", help="find files >= SIZE (e.g. 500M, 1G)")
    ap.add_argument("--samples", type=int, default=10, help="snapshots to scan for --large, spread evenly (default 10)")
    ap.add_argument("--all", action="store_true", help="scan every snapshot for --large (slow)")
    ap.add_argument("--du", action="store_true", help="largest dirs in the latest snapshot")
    ap.add_argument("--churn", action="store_true", help="what changed between the last two snapshots")
    ap.add_argument("--unique", action="store_true", help="tmutil uniquesize for every backup (slow)")
    ap.add_argument("--path", default="", help="limit --large/--du to this path inside the backup, e.g. Users/kism")
    ap.add_argument("--depth", type=int, default=3, help="dir depth for --du/--churn (default 3)")
    ap.add_argument("--top", type=int, default=40, help="rows to show (default 40)")
    args = ap.parse_args()
    sub = args.path.strip("/")

    if sys.platform != "darwin":
        sys.exit("This script is for MacOS only.")
    if os.geteuid() != 0:
        sys.exit("Run with sudo (mounting snapshots needs root).")

    vol = backup_volume()
    section_destination(vol)
    section_exclusions()
    if not vol:
        sys.exit("\nBackup volume not mounted. Open the .sparsebundle on the NAS share (see --help).")
    device = vol[0]
    snaps = list_snapshots(device)
    section_snapshots(snaps)
    if not snaps:
        sys.exit("No backup snapshots found.")

    if args.large:
        picked = snaps if args.all else sample(snaps, args.samples)
        section_large(device, snaps, picked, sub, args.large, args.top)
    if args.du:
        section_du(device, snaps[-1], sub, args.depth, args.top)
    if args.churn and len(snaps) > 1:
        section_churn(device, snaps[-2], snaps[-1], args.depth, args.top)
    if args.unique:
        section_unique(snaps)


if __name__ == "__main__":
    main()

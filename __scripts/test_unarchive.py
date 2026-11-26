#!/usr/bin/env python3
"""Self-check for .local/bin/unarchive, run: python3 __scripts/test_unarchive.py

Builds real archives in a temp dir and extracts them. Formats needing a tool that isn't
installed (zstd, 7z) are skipped, everything python can build itself always runs.
"""

import gzip
import io
import os
import pty
import shutil
import subprocess
import sys
import tarfile
import tempfile
import zipfile
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent.parent / ".local/bin/unarchive"
# Same script with tarfile's PEP 706 filter removed, to cover the fallback used on stock macOS python 3.9
NO_FILTER = (
    "import runpy, sys, tarfile\n"
    "del tarfile.data_filter\n"
    "sys.argv = ['unarchive'] + sys.argv[1:]\n"
    f"runpy.run_path({str(SCRIPT)!r}, run_name='__main__')\n"
)


def run(cwd, *files, legacy=False):
    cmd = [sys.executable, "-c", NO_FILTER] if legacy else [sys.executable, str(SCRIPT)]
    return subprocess.run(
        [*cmd, *map(str, files)], cwd=cwd, capture_output=True, text=True
    )


def run_tty(cwd, answer, *files):
    """Run with stdin on a pseudo-terminal, so the single-folder prompt appears, typing answer"""
    master, slave = pty.openpty()
    try:
        os.write(
            master, answer.encode()
        )  # sits in the tty buffer until the prompt reads it
        cmd = [sys.executable, str(SCRIPT), *map(str, files)]
        return subprocess.run(cmd, cwd=cwd, stdin=slave, capture_output=True, text=True)
    finally:
        os.close(slave)
        os.close(master)


def add(tf, name, data=b"x", **attrs):
    info = tarfile.TarInfo(name)
    info.size = len(data)
    for k, v in attrs.items():
        setattr(info, k, v)
    tf.addfile(info, io.BytesIO(data))


def main():
    t = Path(tempfile.mkdtemp())
    try:
        # single top-level folder -> used as-is, not nested inside a folder named after the archive
        with tarfile.open(t / "proj-1.0.tar.gz", "w:gz") as tf:
            add(tf, "proj-1.0/README", b"hi")
        # loose files -> folder named after the archive
        with tarfile.open(t / "loose.tar.xz", "w:xz") as tf:
            add(tf, "a")
            add(tf, "b")
        # zip keeps the exec bit
        with zipfile.ZipFile(t / "tool.zip", "w") as zf:
            zi = zipfile.ZipInfo("run.sh")
            zi.external_attr = 0o100755 << 16
            zf.writestr(zi, "#!/bin/sh\n")
            zf.writestr("data.txt", "d")
        # single compressed file -> just decompressed
        (t / "notes.txt.gz").write_bytes(gzip.compress(b"notes"))

        r = run(t, "proj-1.0.tar.gz", "loose.tar.xz", "tool.zip", "notes.txt.gz")
        assert r.returncode == 0, r.stderr
        assert (t / "proj-1.0/README").read_bytes() == b"hi"
        assert (t / "loose/a").exists() and (t / "loose/b").exists()
        assert (t / "tool/run.sh").stat().st_mode & 0o100, "exec bit lost"
        assert (t / "notes.txt").read_bytes() == b"notes"

        # name taken -> -1, never overwrite
        r = run(t, "loose.tar.xz", "notes.txt.gz")
        assert r.returncode == 0, r.stderr
        assert (t / "loose-1/a").exists() and (t / "notes.txt-1").exists()

        # path traversal and escaping symlinks are refused, with and without the PEP 706 filter
        with tarfile.open(t / "evil.tar", "w") as tf:
            add(tf, "ok")
            add(tf, "../escaped")
        with tarfile.open(t / "evil-link.tar", "w") as tf:
            add(tf, "link", b"", type=tarfile.SYMTYPE, linkname="/etc/passwd")
        legacy_modes = [False, True] if hasattr(tarfile, "data_filter") else [False]
        for legacy in legacy_modes:
            for evil in ("evil.tar", "evil-link.tar"):
                r = run(t, evil, legacy=legacy)
                assert r.returncode == 1, (evil, legacy, r.stdout, r.stderr)
        assert not (t.parent / "escaped").exists()
        assert not list(t.glob(".unarchive-*")), "temp folder left behind"
        assert not (t / "evil").exists() and not (t / "evil-link").exists()

        # garbage and missing files fail cleanly, the rest of the args still run
        (t / "junk.zip").write_bytes(b"not a zip")
        r = run(t, "junk.zip", "missing.tar", "proj-1.0.tar.gz")
        assert r.returncode == 1 and (t / "proj-1.0-1/README").exists(), r.stderr
        assert "Traceback" not in r.stderr, r.stderr

        # single-folder prompt, only shown on a terminal, previews both paths
        p = t / "prompt"
        p.mkdir()
        with tarfile.open(p / "download.tar.gz", "w:gz") as tf:
            add(tf, "proj-2.0/README", b"hi")
        with tarfile.open(p / "same.tar.gz", "w:gz") as tf:
            add(tf, "same/README", b"hi")
        r = run_tty(p, "n\n", "download.tar.gz")
        assert r.returncode == 0, r.stderr
        assert (
            "[Y] ./proj-2.0/" in r.stderr and "[n] ./download/proj-2.0/" in r.stderr
        ), r.stderr
        assert (p / "download/proj-2.0/README").exists(), "n should nest"
        r = run_tty(p, "\n", "download.tar.gz")  # enter = default yes
        assert r.returncode == 0 and (p / "proj-2.0/README").exists(), r.stderr
        r = run_tty(p, "\n", "download.tar.gz")  # preview shows the -1 name when taken
        assert (
            "[Y] ./proj-2.0-1/" in r.stderr and "[n] ./download-1/proj-2.0/" in r.stderr
        ), r.stderr
        r = run_tty(
            p, "n\n", "same.tar.gz"
        )  # names match: no prompt, answer never read
        assert "[Y]" not in r.stderr and (p / "same/README").exists(), r.stderr
        assert not list(p.glob(".unarchive-*")), "temp folder left behind"

        # formats that need an external tool
        src = t / "src"
        (src / "inner").mkdir(parents=True)
        (src / "inner/f").write_text("f")
        if shutil.which("zstd"):
            with tarfile.open(t / "z.tar", "w") as tf:
                tf.add(src / "inner", "inner")
            subprocess.run(["zstd", "-q", "--rm", str(t / "z.tar")], check=True)
            r = run(t, "z.tar.zst")
            assert r.returncode == 0 and (t / "inner/f").read_text() == "f", r.stderr
            print("ok zstd")
        else:
            print("skipped zstd, not installed")
        sevenzip = shutil.which("7zz") or shutil.which("7z")
        if sevenzip:
            subprocess.run(
                [sevenzip, "a", "-bso0", str(t / "s.7z"), str(src / "inner")],
                check=True,
            )
            r = run(t, "s.7z")
            assert r.returncode == 0, r.stderr
            print("ok 7z")
        else:
            print("skipped 7z, not installed")
    finally:
        shutil.rmtree(t)
    print("all unarchive checks passed")


if __name__ == "__main__":
    main()

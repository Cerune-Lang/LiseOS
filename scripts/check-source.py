#!/usr/bin/env python3
"""M1a source policy: no non-Cerune kernel files."""
from pathlib import Path
from sys import exit

root = Path(__file__).resolve().parent.parent
kernel = root / "kernel"
allowed = {".ceru"}
bad = [p for p in kernel.rglob("*") if p.is_file() and p.suffix not in allowed]
if bad:
    print("Non-Cerune source under kernel/:", *(str(x) for x in bad), sep="\n")
    exit(1)
print("Kernel source policy OK: kernel/ contains Cerune sources only")

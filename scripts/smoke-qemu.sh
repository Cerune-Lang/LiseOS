#!/usr/bin/env bash
# Automated entry observation: boots the ISO until the CPU reaches Cerune's main.
# This is *not* a serial/console test and not evidence for later OS features.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="${BUILD_DIR:-$ROOT/build}"
GDB_PORT="${LISEOS_GDB_PORT:-1234}"
command -v timeout >/dev/null
command -v gdb >/dev/null
command -v qemu-system-x86_64 >/dev/null
test -f "$BUILD/liseos.iso" || { echo "missing ISO: bash scripts/iso.sh" >&2; exit 1; }
test -f "$BUILD/liseos.elf"

QEMU_LOG="$BUILD/qemu-smoke.log"
GDB_LOG="$BUILD/gdb-smoke.log"
qemu-system-x86_64 -machine q35 -m 256M -cdrom "$BUILD/liseos.iso" -boot d \
  -display none -serial none -monitor none -no-reboot -S \
  -gdb "tcp:127.0.0.1:$GDB_PORT" >"$QEMU_LOG" 2>&1 &
QEMU_PID=$!
cleanup() {
    kill "$QEMU_PID" 2>/dev/null || :
    wait "$QEMU_PID" 2>/dev/null || :
}
trap cleanup EXIT

# GDB runs only after QEMU exposes its stub. Do not silently accept a timeout.
python3 - "$GDB_PORT" <<'PY'
import socket, sys, time
port = int(sys.argv[1])
for _ in range(100):
    try:
        with socket.create_connection(("127.0.0.1", port), timeout=0.3):
            break
    except OSError:
        time.sleep(0.1)
else:
    raise SystemExit("QEMU GDB port never became ready")
PY

timeout 65s gdb -q -nx -batch \
  -ex "file $BUILD/liseos.elf" \
  -ex "set pagination off" \
  -ex "set confirm off" \
  -ex "set architecture i386:x86-64" \
  -ex "target remote 127.0.0.1:$GDB_PORT" \
  -ex "hbreak main" \
  -ex "continue" \
  -ex 'python import gdb; pc=int(gdb.parse_and_eval("$pc")); target=int(gdb.parse_and_eval("&main")); assert pc == target, f"wrong RIP: {pc:#x} vs {target:#x}"; print("LiseOS M1a: QEMU reached Cerune main")' \
  >"$GDB_LOG" 2>&1 || {
    cat "$GDB_LOG" >&2
    echo 'QEMU entry smoke failed' >&2
    exit 1
  }
grep -F 'LiseOS M1a: QEMU reached Cerune main' "$GDB_LOG" >/dev/null || {
  cat "$GDB_LOG" >&2
  echo "entry observation marker missing" >&2
  exit 1
}
cat "$GDB_LOG"

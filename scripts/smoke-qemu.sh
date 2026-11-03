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
MONITOR_SOCKET="$BUILD/qemu-monitor.sock"
rm -f "$MONITOR_SOCKET"
qemu-system-x86_64 -machine q35 -m 256M -cdrom "$BUILD/liseos.iso" -boot d \
  -display none -serial none -no-reboot -S \
  -monitor "unix:$MONITOR_SOCKET,server=on,wait=off" \
  -d guest_errors,unimp -D "$BUILD/qemu-debug.log" \
  -debugcon "file:$BUILD/qemu-debugcon.log" -global isa-debugcon.iobase=0xe9 \
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

timeout 25s gdb -q -nx -batch \
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
    python3 - "$MONITOR_SOCKET" "$BUILD" <<'PYMON' || true
import socket, sys, time
from pathlib import Path
sock, directory = sys.argv[1:]
commands = [f"screendump {directory}/boot-screen.ppm", "info registers", "info status"]
try:
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.settimeout(3)
        s.connect(sock)
        try:
            s.recv(65535)
        except TimeoutError:
            pass
        for command in commands:
            s.sendall((command + "\\n").encode())
            time.sleep(0.25)
            try:
                result = s.recv(65535).decode("utf-8", "replace")
                if command != "info registers" or len(result) < 20000:
                    print(result)
                Path(directory, "qemu-monitor-dump.log").open("a").write(command+"\\n"+result+"\\n")
            except TimeoutError:
                pass
except (OSError, TimeoutError) as e:
    print(f"Failed to collect QEMU monitor details: {e}", file=sys.stderr)
PYMON
    cat "$QEMU_LOG" >&2
    echo 'QEMU entry smoke failed; diagnostic files are uploaded as CI artifacts' >&2
    exit 1
  }
grep -F 'LiseOS M1a: QEMU reached Cerune main' "$GDB_LOG" >/dev/null || {
  cat "$GDB_LOG" >&2
  echo "entry observation marker missing" >&2
  exit 1
}
cat "$GDB_LOG"

#!/usr/bin/env bash
# Start QEMU paused with GDB server so entry execution can be observed.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="${BUILD_DIR:-$ROOT/build}"
ISO="$BUILD/liseos.iso"
if [[ ! -f "$ISO" ]]; then
    echo "ISO missing; run scripts/iso.sh first" >&2
    exit 1
fi
exec qemu-system-x86_64 \
    -machine q35 -m 256M -cdrom "$ISO" -boot d \
    -display none -serial mon:stdio \
    -no-reboot -no-shutdown -S -s

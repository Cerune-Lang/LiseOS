#!/usr/bin/env bash
# LiseOS M1a: Cerune source -> freestanding ELF64, no kernel C/ASM.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="${BUILD_DIR:-$ROOT/build}"
CC_LINK="${LD_LLD:-ld.lld}"
CERUNE_CARGO="${CARGO:-cargo}"
mkdir -p "$BUILD"

"$CERUNE_CARGO" run --quiet --manifest-path "$ROOT/tools/object-builder/Cargo.toml" -- \
    "$ROOT/kernel/main.ceru" "$BUILD/kernel.o"

python3 "$ROOT/scripts/audit_elf.py" --object "$BUILD/kernel.o"

"$CC_LINK" -nostdlib -static --no-undefined -z max-page-size=0x1000 \
    -T "$ROOT/linker.ld" -Map "$BUILD/liseos.map" \
    -o "$BUILD/liseos.elf" "$BUILD/kernel.o"

python3 "$ROOT/scripts/audit_elf.py" --kernel "$BUILD/liseos.elf"
printf 'LiseOS ELF built: %s\n' "$BUILD/liseos.elf"
printf 'NOTE: Build success is NOT a verified QEMU boot.\n'

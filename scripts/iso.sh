#!/usr/bin/env bash
# Build an ISO with a pinned Limine v11.4.1 binary release.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="${BUILD_DIR:-$ROOT/build}"
LIMINE_COMMIT="5be26a73d7b7b4d4477d18be94e1d16e615adf56"
LIMINE_DIR="$ROOT/deps/limine"
LIMINE_URL="https://github.com/Limine-Bootloader/Limine.git"

command -v git >/dev/null
command -v xorriso >/dev/null || { echo 'xorriso is required' >&2; exit 1; }

"$ROOT/scripts/build.sh"

if [[ ! -e "$LIMINE_DIR/.git" ]]; then
    mkdir -p "$ROOT/deps"
    git clone --depth 1 --branch v11.4.1-binary "$LIMINE_URL" "$LIMINE_DIR"
fi
CURRENT="$(git -C "$LIMINE_DIR" rev-parse HEAD)"
if [[ "$CURRENT" != "$LIMINE_COMMIT" ]]; then
    echo "Limine revision mismatch. Expected $LIMINE_COMMIT got $CURRENT" >&2
    exit 1
fi
for f in limine-bios-cd.bin limine-uefi-cd.bin BOOTX64.EFI; do
    test -f "$LIMINE_DIR/$f" || { echo "missing Limine binary: $f" >&2; exit 1; }
done

# The host Limine utility patches the BIOS ISO boot sectors.
if [[ ! -x "$LIMINE_DIR/limine" ]]; then
    command -v make >/dev/null
    make -C "$LIMINE_DIR"
fi
mkdir -p "$BUILD/iso_root/boot/limine" "$BUILD/iso_root/EFI/BOOT"
cp "$BUILD/liseos.elf" "$BUILD/iso_root/boot/liseos.elf"
cp "$ROOT/limine.conf" "$BUILD/iso_root/boot/limine/limine.conf"
cp "$LIMINE_DIR/limine-bios-cd.bin" "$LIMINE_DIR/limine-uefi-cd.bin" "$BUILD/iso_root/boot/"
cp "$LIMINE_DIR/BOOTX64.EFI" "$BUILD/iso_root/EFI/BOOT/BOOTX64.EFI"

xorriso -as mkisofs -R -r -J \
    -b boot/limine-bios-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table \
    --efi-boot boot/limine-uefi-cd.bin -efi-boot-part --efi-boot-image \
    --protective-msdos-label "$BUILD/iso_root" -o "$BUILD/liseos.iso"

"$LIMINE_DIR/limine" bios-install "$BUILD/liseos.iso"
echo "ISO generated: $BUILD/liseos.iso"
echo "NOTE: This does not establish that QEMU successfully booted the kernel."

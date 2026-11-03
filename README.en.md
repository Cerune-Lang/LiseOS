# LiseOS

**LiseOS** (pronounced *Lee-sa OS*) is an experimental operating system whose **kernel implementation is written in [Cerune](https://github.com/Cerune-Lang/Cerune)**.

> **Status: M1a bootstrap implementation committed; boot not yet verified.** First target: **x86-64/QEMU**. The minimal Cerune entry, ELF build/audit, Limine ISO packaging and QEMU/GDB test scripts exist, but a successful boot has **not** been observed.

[日本語](README.md) · [Limine boot notes (Japanese)](docs/boot/limine.md) · [ADR-0001: x86-64/QEMU](docs/decisions/0001-target-x86-64-qemu.md) · [ADR-0002: Cerune-only kernel](docs/decisions/0002-cerune-only-kernel.md)

## Policy

- **Use Cerune for kernel/runtime code.** Do not write a throwaway C/assembly kernel first.
- Treat missing low-level capabilities as explicit Cerune compiler/language tasks.
- Rust host utilities, an LLVM linker, Limine, QEMU and Python/Bash test tools are permitted, since they do not run as the kernel.
- Defer Cisa support until the x86-64 kernel foundations are stable.

## M1a: Reach the kernel entry

```text
kernel/main.ceru
      ↓ Cerune object builder (host-only Rust utility)
  ELF64 object
      ↓ ld.lld + linker.ld
  liseos.elf
      ↓ Limine + QEMU
  x86-64 entry: main
      ↓
  Cerune infinite loop (no output yet)
```

This first source contains only a loop. `LiseOS: boot ok` on a serial console is the **future M1b objective**, after Cerune gains explicit low-level I/O support. The existing `print` operation relies on host OS facilities and cannot be used directly in a kernel.

`linker.ld` currently lays out minimal Limine boot request tags as data. Read [the Limine notes](docs/boot/limine.md) for the role of Limine, the chosen boot protocol and pinned dependency.

## Build and verify (Linux / WSL2)

Required: Rust/Cargo, Python 3, `ld.lld`, Git, GNU Make, xorriso, QEMU and GDB.

```sh
python3 scripts/check-source.py
cargo test --manifest-path tools/object-builder/Cargo.toml
bash scripts/build.sh
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

- `build.sh` generates a Cerune object and ELF, checking undefined symbols and dynamic loader dependence.
- `iso.sh` packages an ISO using pinned **Limine v11.4.1**.
- `smoke-qemu.sh` uses QEMU's GDB stub to observe execution reaching the Cerune `main`.
- `bash scripts/debug-qemu.sh` opens a manual QEMU/GDB debugging session.

**Build success is not boot success.** M1a requires observable control transfer to the entry point.

## Milestones

| Phase | Goal | Status |
| --- | --- | --- |
| M0 | x86-64/QEMU, Limine, Cerune-only kernel decision | **Accepted** |
| M1a | Cerune → ELF → Limine → QEMU entry observation | **Initial implementation, unverified** |
| M1b | Serial output and controlled halt via Cerune I/O | **Not implemented** |
| M2 | Exceptions and physical memory | **Planned** |
| M3 | Interrupts and tasks | **Planned** |
| Later | Consider Cisa port | **Deferred** |

## Layout

- `kernel/main.ceru` — Cerune kernel entry
- `tools/object-builder/` — **host-only** Rust wrapper around Cerune native Object API
- `linker.ld`, `limine.conf` — binary/link layout and boot config
- `scripts/` — build, ISO, static audit, QEMU/GDB inspection
- `.github/workflows/bootstrap.yml` — CI smoke tests
- `docs/boot/limine.md`, `docs/decisions/` — design documentation

## Related projects

[Cerune](https://github.com/Cerune-Lang/Cerune) · [Sashimi](https://github.com/Cerune-Lang/Sashimi) · [Cisa](https://github.com/Cerune-Lang/Cisa) (possible future port).

## License

Undecided. Define licensing and contribution terms before accepting third-party code.

# LiseOS

[日本語](README.md) | English

LiseOS (pronounced *Lee-sa OS*) is an experimental operating system with a kernel written in [Cerune](https://github.com/Cerune-Lang/Cerune). It targets x86-64 under QEMU and uses [Limine](https://github.com/Limine-Bootloader/Limine) to boot.

A minimal Cerune kernel and build/boot test tools are available. Serial output and memory management are not implemented yet.

[![CI](https://github.com/Cerune-Lang/LiseOS/actions/workflows/bootstrap.yml/badge.svg)](https://github.com/Cerune-Lang/LiseOS/actions/workflows/bootstrap.yml)
[![License: MIT OR Apache-2.0](https://img.shields.io/badge/license-MIT%20OR%20Apache--2.0-blue)](#license)

## Build and run

On Linux or WSL2, install Rust, Python 3, LLVM lld, Git, Make, xorriso, QEMU, and GDB.

```sh
git clone https://github.com/Cerune-Lang/LiseOS.git
cd LiseOS
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

`iso.sh` builds an ELF kernel from Cerune and packages a bootable ISO. `smoke-qemu.sh` checks whether QEMU reaches the kernel's `main` using GDB.

Check results in [GitHub Actions](https://github.com/Cerune-Lang/LiseOS/actions).

## Source and documentation

- [kernel/main.ceru](kernel/main.ceru) — kernel source
- [Implementation notes](docs/design/implementation.md) — tools and files (Japanese)
- [Limine bootloader](docs/boot/limine.md) — boot process (Japanese)

## Repository layout

| Path | Purpose |
| --- | --- |
| `kernel/` | Kernel implementation written in Cerune |
| `tools/object-builder/` | Host-side Rust tool to generate ELF objects from Cerune |
| `scripts/` | Build, ELF audit, ISO packaging, and QEMU smoke checks |
| `docs/` | Implementation design and Limine boot notes |
| `licenses/limine/` | Bundled Limine license and third-party notices |

## Development checks

```sh
python3 scripts/check-source.py
cargo test --manifest-path tools/object-builder/Cargo.toml
bash scripts/build.sh
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

The [CI workflow](.github/workflows/bootstrap.yml) runs these checks too. The boot smoke check only verifies that QEMU reaches the Cerune `main` entry point; it does not establish that display output, memory management, or other OS functionality works.

## Related repositories

[Cerune](https://github.com/Cerune-Lang/Cerune) · [Sashimi](https://github.com/Cerune-Lang/Sashimi) · [Cisa](https://github.com/Cerune-Lang/Cisa)

## License

LiseOS is dual-licensed under either of:

- [MIT License](LICENSE-MIT)
- [Apache License 2.0](LICENSE-APACHE)

at your option.

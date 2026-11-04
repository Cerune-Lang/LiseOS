# Contributing

[日本語](CONTRIBUTING.md) | English

Bug reports, tests, documentation fixes, and small improvements to LiseOS are welcome. LiseOS is an experimental OS under active development, so its implementation and structure may change.

## Getting started

- Read the [README](README.en.md) and [implementation notes](docs/design/implementation.md) to understand the current scope.
- Check [existing issues](https://github.com/Cerune-Lang/LiseOS/issues) and pull requests before starting.
- Discuss larger features or architectural changes in an issue before implementing them.

## Bug reports and proposals

When filing an issue, include as much as possible: commands used, expected and actual behavior, host OS, QEMU and Limine versions, LiseOS commit, and minimal reproducing source or logs.

Do not disclose security concerns in public issues. Follow [SECURITY.md](SECURITY.md) to report them privately.

## Implementation policy

- Kernel runtime code must be written in **Cerune**. Keep only `.ceru` sources under `kernel/`; do not introduce C, Assembly, or Rust kernel runtime code.
- Rust, Python, Bash, and the linker may be used for host-side development tools.
- Distinguish a successful build from a verified boot. The current QEMU smoke test only checks that execution reaches the kernel's `main`; it does not prove that display output or serial I/O is implemented.
- When changing pinned Limine or Cerune revisions, explain the reason, impact, and validation performed.

## Development and checks

On Linux / WSL2, install Rust, Python 3, LLVM lld, Git, Make, xorriso, QEMU, and GDB.

```sh
git clone https://github.com/Cerune-Lang/LiseOS.git
cd LiseOS
python3 scripts/check-source.py
cargo test --manifest-path tools/object-builder/Cargo.toml
bash scripts/build.sh
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

Some checks require external tools and time. If you cannot run them locally, say why in your pull request. CI runs these checks too.

## Pull requests

- Keep each PR focused and explain what changed and why.
- Link relevant issues and list commands run and their results.
- Where practical, add checks for changes that affect behavior.
- Update both Japanese and English documentation as appropriate.
- Disclose any limitations or unverified behavior.

Small fixes and questions are welcome.

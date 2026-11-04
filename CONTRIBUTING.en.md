# Contributing

[日本語](CONTRIBUTING.md) | English

Thank you for your interest in LiseOS. Bug reports, testing, documentation fixes, and small improvements are welcome. LiseOS is an experimental OS under active development, so its design and implementation may change.

## Getting started

- Review the [README](README.en.md), [implementation notes](docs/design/implementation.md), and [Limine boot notes](docs/boot/limine.md).
- Check [existing issues](https://github.com/Cerune-Lang/LiseOS/issues). Discuss major design changes and dependency updates in an issue before implementing them.
- Keep the kernel in `kernel/` **Cerune-only (`.ceru`)**. Rust, Python, Bash, and other languages are used for host-side build and verification tooling.

## Reporting bugs and proposing changes

When opening a public issue, please include where possible:

- Commands you ran and the smallest change needed to reproduce the problem
- Expected behavior versus actual behavior and logs
- The LiseOS commit, host operating system, and tool versions (such as QEMU)
- Whether the issue occurs during ELF generation, ISO creation, or QEMU boot checks

**Do not report security issues in a public issue.** Follow [SECURITY.md](SECURITY.md) instead.

## Development and checks

On Linux or WSL2, install the dependencies listed in the README: Rust, Python 3, LLVM lld, Git, Make, xorriso, QEMU, and GDB.

```sh
git clone https://github.com/Cerune-Lang/LiseOS.git
cd LiseOS
python3 scripts/check-source.py
cargo test --manifest-path tools/object-builder/Cargo.toml
bash scripts/build.sh
bash scripts/iso.sh
bash scripts/smoke-qemu.sh
```

`build.sh` checks ELF generation; `smoke-qemu.sh` observes whether QEMU reaches the Cerune `main` entry point using GDB. These checks do not verify display output, memory management, or broader OS functionality. If you cannot run a check in your environment, note that in your PR.

The Limine and Cerune compiler dependencies are pinned. Explain why any updates are needed and how they affect the boot checks.

## Pull requests

- Keep each PR focused and open it against `main`.
- Describe what changed and why, the checks performed and their results, and related issues.
- For kernel, build, or boot changes, update relevant tests and documentation.
- Update Japanese and English documentation pairs where practical.
- Ensure that you have the right to submit the code under LiseOS's [MIT OR Apache-2.0](README.en.md#license) terms.

Small fixes and questions are welcome.

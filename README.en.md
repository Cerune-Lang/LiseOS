# LiseOS

**LiseOS** (pronounced *Lee-sa OS*; Japanese: リーサOS) is an experimental operating-system project growing alongside the Cerune ecosystem.

> **Status: planning / bootstrap.** This repository is newly initialized. No bootable kernel, shell, filesystem, or application runtime is claimed to exist yet.

[日本語](README.md)

## Goals

- Explore boot, memory, exceptions and interrupts, I/O, and task/process management through small implementations and reproducible tests.
- Make internal behavior and failures observable, while distinguishing design proposals from verified functionality.
- Explore potential connections with [Cerune](https://github.com/Cerune-Lang/Cerune), [Cisa](https://github.com/Cerune-Lang/Cisa), and [Sashimi](https://github.com/Cerune-Lang/Sashimi). No integration is promised at this stage.

## Initial execution targets under consideration

| Candidate | First milestone | Constraint |
| --- | --- | --- |
| **Cisa guest environment** | Start, produce output, and halt inside Cisa's virtual CPU | Privilege isolation, interrupts, and similar OS features may require extending Cisa. A guest on an emulator is not a standalone hardware OS. |
| **x86-64 / QEMU** | Boot a minimal kernel via a bootloader and demonstrate output and shutdown | Requires freestanding build support, boot protocol, ABI, linking, and further platform work. |

The first official target is **not decided**. Writing an entire kernel in Cerune is also **not yet validated**.

## Proposed milestones

1. **M0 — Target and boundaries:** Choose a target, toolchain, and reproducible build/test process.
2. **M1 — Boot / Hello / Halt:** Start a minimal program, emit recognizable output, and halt safely.
3. **M2 — Memory and failures:** Observe memory layout and failure behavior on the chosen target.
4. **M3 — Minimal OS facilities:** Scope interrupts, tasks, system calls, or other facilities based on the target.

All milestones are **proposals**, not completed features.

## Engineering principles

- Implement the smallest testable slice first.
- Distinguish *documented*, *implemented*, *booted*, and *tested*.
- Do not equate emulator success with physical hardware support or security assurance.
- Update architecture decisions in response to reproducible evidence.

## Related projects

- [Cerune](https://github.com/Cerune-Lang/Cerune) — programming language, compiler, and runtimes
- [Cisa](https://github.com/Cerune-Lang/Cisa) — experimental virtual CPU written in Cerune
- [Sashimi](https://github.com/Cerune-Lang/Sashimi) — Rust x86-64 assembler and object generation library

## License

Not yet decided. Clarify the license and contribution policy before accepting third-party code contributions.

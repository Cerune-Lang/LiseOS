# LiseOS

**LiseOS** (pronounced *Lee-sa OS*; Japanese: リーサOS) is an experimental operating-system project growing alongside the Cerune ecosystem.

> **Status: bootstrap / not yet implemented.** The first target is **x86-64 / QEMU**. This does not mean the kernel boots or that OS services already exist.

[日本語](README.md) · [Architecture decision: ADR-0001](docs/decisions/0001-target-x86-64-qemu.md)

## First objective

**Boot a LiseOS kernel in QEMU, print an observable serial message, and stop deliberately.**

Proposed initial layout:

```text
QEMU (x86-64)
  -> Limine bootloader
     -> freestanding LiseOS kernel
        -> serial output: "LiseOS: boot ok"
        -> deliberate halt / QEMU exit
```

M1 is complete only after **an observed QEMU boot**, not merely compilation. See [ADR-0001](docs/decisions/0001-target-x86-64-qemu.md) for acceptance criteria.

## Platform and porting policy

| Platform | Role | Status |
| --- | --- | --- |
| **x86-64 / QEMU** | Initial primary target via Limine | **Chosen / not yet implemented** |
| **Cisa** | Potential port only after the kernel foundation is stable | **Future** |
| **Physical x86-64** | Needs separate hardware and driver validation | **Out of scope for now** |

C and minimal assembly are permitted for bootstrap. **A fully Cerune-written freestanding kernel is not yet proven feasible.** Investigate Cerune's freestanding output, ABI, linking, memory operations and runtime requirements separately before integrating generated kernel code.

## Milestones

1. **M0 — Direction:** x86-64/QEMU target and boot strategy documented. **Decision accepted**
2. **M1 — Boot / Hello / Halt:** Reproducible build, Limine boot, serial message, deliberate stop. **Not implemented**
3. **M2 — Exceptions / Memory:** Observe exceptions, inspect memory map, explore minimal physical page management. **Planned**
4. **M3 — Interrupts / Tasks:** Add timer interrupts and task execution incrementally. **Planned**
5. **M4+:** Consider user mode, system calls and other services as justified by tests. Evaluate a Cisa port later.

## Engineering principles

- Prefer the smallest independently testable increment.
- Distinguish documented, implemented, booted, and tested.
- Do not equate QEMU success with real hardware compatibility or security.
- Record evidence and preserve opportunities for incremental Cerune integration.

## Related projects

- [Cerune](https://github.com/Cerune-Lang/Cerune) — language, compiler and runtimes
- [Cisa](https://github.com/Cerune-Lang/Cisa) — experimental virtual CPU written in Cerune (not an initial target)
- [Sashimi](https://github.com/Cerune-Lang/Sashimi) — Rust x86-64 assembler and object generation library

## License

Not yet decided. Clarify the license and contribution policy before accepting third-party code contributions.

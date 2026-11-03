# ADR-0001: Start with x86-64 / QEMU

- **Status:** Accepted
- **Date:** 2026-11-04
- **Scope:** First target and boot path
- **See also:** [ADR-0002: Cerune-only kernel](0002-cerune-only-kernel.md)

## Decision

LiseOS initially targets **x86-64/QEMU**, using **Limine** as an existing bootloader. Build the **kernel itself in Cerune**, rather than using a C/assembly bootstrap kernel.

The first observable milestone is **M1a**, transferring execution to Cerune-generated `main` (infinite loop, no I/O yet). **M1b** will add controlled serial output and halt only once the required hardware interfaces exist in Cerune.

Cisa is a future port, not an initial target.

## Why

1. QEMU isolates kernel development from designing another virtual CPU at the same time.
2. Limine handles firmware- and disk-boot concerns, allowing LiseOS to concentrate on the kernel.
3. Writing kernel code in Cerune from the start drives the language's freestanding capabilities.
4. Existing host tools (Rust compiler process, linker, image builder, debugger) are not part of the kernel and remain available.

## Initial constraints

- **Kernel source:** Cerune only.
- **Host build tools:** Rust/Cargo for the Cerune API, `ld.lld`, Python/Bash, Limine, QEMU, GDB.
- **Boot format:** x86-64 ELF64 high-half executable.
- **Protocol:** Limine, minimal request markers/base revision, version pinned in [boot docs](../boot/limine.md).
- **Evidence:** Link and ELF audits are not enough. QEMU with GDB must observe reaching `main`.
- **Not yet demonstrated:** freestanding kernel boot, serial I/O, interrupts, memory management, hardware compatibility.

## Roadmap

- **M0:** Architectural decision accepted.
- **M1a:** Cerune object, high-half ELF, Limine ISO, QEMU entry observation (implementation committed; not yet observed).
- **M1b:** Cerune hardware I/O + serial output + deliberate stop.
- **M2:** Exception and memory handling.
- **M3:** Interrupts and tasks.
- **Later:** Evaluate Cisa migration with a documented feature-gap analysis.

## Revisit when

A reproducible test invalidates an assumption in the initial Limine or Cerune object flow, or Cerune gains a first-class freestanding target and boot-protocol data layout support.

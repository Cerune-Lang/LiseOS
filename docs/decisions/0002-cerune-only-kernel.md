# ADR-0002: Cerune-only kernel, no host-language bootstrap

- **Status:** Accepted
- **Date:** 2026-11-04
- **Supersedes:** The early C/assembly bootstrap allowance in ADR-0001.
- **Scope:** Runtime/guest kernel code, not host tools or third-party bootloader.

## Decision

LiseOS **kernel implementation is written in Cerune**. Do not bootstrap a separate C or assembly kernel and promise to translate it later.

Host tooling (Rust/Cargo for the Cerune compiler, Python/Bash for inspection, LLVM linker, QEMU, Limine) is permitted. Tool implementation language does not make it part of LiseOS runtime.

`linker.ld` currently emits minimal protocol markers as link-time *data layout*. This is a temporary toolchain limitation, not an alternative-language kernel. We should migrate protocol data layout into Cerune once supported.

## First executable step (M1a)

1. `kernel/main.ceru` contains the kernel entry with a non-returning infinite loop.
2. `tools/object-builder` calls `compile_to_native_object` directly, avoiding the Cerune CLI's default call-depth diagnostic runtime.
3. Audit the ELF64 object for undefined symbols and the linked ELF for host interpreter/dynamic-loader dependence.
4. Link it to a high-half ELF and package it with Limine into an ISO.
5. Observe entry in **QEMU with GDB**. A successful static build is not boot verification.

There is **no serial output yet**, because the current `print` operation is host-dependent. M1b should add a principled hardware-access interface to Cerune before attempting serial output.

## Non-goals

- C/assembly source inside `kernel/`.
- Writing an entire bootloader.
- Promising current production viability of Cerune as an OS language.
- A Cisa port before the x86-64 kernel foundation works.
- Real hardware support.

## Known limitations

- Current Cerune native object target is named `x86_64-unknown-linux-gnu`. The object generator only borrows its ISA/ELF conventions. This does **not** make Linux runtime dependencies acceptable.
- Only an extremely restricted source subset can pass the no-external-reference audit.
- The linker script controls the boot protocol's request markers and entry address. It is not yet authored in Cerune.
- No code has been successfully QEMU-booted just by adding these files.
- This decision does not itself establish the correctness of the compiler, ABI, bootloader integration, or memory invariants.

## Future exit criteria

Consider M1a complete only after: object/ELF audits pass, image is built, QEMU loads it, and GDB demonstrates the instruction pointer at the Cerune-generated `main` entry. Preserve command output or a reproducible CI log.

See [Limine boot notes](../boot/limine.md).

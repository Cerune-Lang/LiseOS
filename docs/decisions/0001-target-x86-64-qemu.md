# ADR-0001: Start with x86-64 / QEMU

- **Status:** Accepted
- **Date:** 2026-11-04
- **Scope:** LiseOS bootstrap and first hardware target

## Decision

LiseOS will first target **x86-64 under QEMU**.

Use an established bootloader, initially **Limine**, to enter 64-bit kernel code. Focus on a reproducible **boot -> serial output -> controlled stop** path before implementing memory allocation, exceptions, interrupts, or scheduling.

**Cisa is a possible future port, not an initial platform.** Its current instruction set and machine model should not be forced to grow just to satisfy early kernel bring-up.

## Why

1. QEMU provides a mature, reproducible x86-64 execution environment with widely documented debugging facilities.
2. Separating emulator/virtual CPU development from kernel development makes failures easier to attribute.
3. A bootloader reduces unrelated early work on firmware, disk layout, and mode switching.
4. Once kernel interfaces and invariants are tested on a stable target, the cost and requirements of porting to Cisa will be much clearer.

## Initial implementation boundary

- **Boot environment:** Limine protocol, x86-64 ELF kernel, QEMU. Choose a pinned protocol and bootloader version when adding the build.
- **Bootstrap language:** C and minimal assembly are allowed for early freestanding bring-up. Do not claim Cerune can build a freestanding kernel until independently verified.
- **Cerune integration:** Investigate object output, SysV calling convention, linker compatibility, runtime dependencies, intrinsics and memory access in isolated experiments. Migrate subsystems only when tests prove viability.
- **Cisa:** Treat as a later portability project. Any future port will require a separate platform capability assessment (interrupts, memory, privilege, I/O, executable format).
- **Safety:** Emulator boot does not imply real hardware support.

## First executable milestone: M1

**Boot / Hello / Halt** must be observable, not merely buildable.

Acceptance criteria:

1. A documented command builds a freestanding x86-64 ELF kernel and a bootable medium.
2. A documented QEMU invocation starts it via Limine.
3. QEMU serial output includes an unambiguous line such as `LiseOS: boot ok`.
4. A deliberate halt/exit path is observable; a crash, triple fault, or timeout must not count as success.
5. A clean environment can reproduce the steps; record compiler/bootloader/QEMU versions.

Prefer headless execution for smoke tests (`-display none -serial stdio` where appropriate); avoid conflating debug-output-only or compile-only checks with a real boot test.

## Subsequent milestones

- **M2:** exception handling and memory-map inspection, then physical page allocation.
- **M3:** timer/interrupt setup and basic cooperative/preemptive task experiments.
- **M4:** system-call/user-mode boundary only after the above are tested.
- **Later:** evaluate Cisa backend/guest port and additional architectures.

## Revisit when

- Cerune gains experimentally verified freestanding and kernel-friendly codegen.
- QEMU bring-up reveals assumptions that should change the boot approach.
- Cisa acquires a sufficiently complete and tested platform specification for an OS port.

## Reference

- [Limine C template (x86-64)](https://github.com/Limine-Bootloader/limine-c-template-x86-64)
- [Limine Bare Bones (OSDev Wiki)](https://wiki.osdev.org/Limine_Bare_Bones)

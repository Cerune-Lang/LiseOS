#!/usr/bin/env python3
"""Reject obvious host-runtime dependencies in the earliest kernel artifact.

Only handles ELF64 little-endian, x86-64. It is a bootstrap audit, not a
complete ELF validator. Linker's --no-undefined is an independent backstop.
"""
import argparse
import struct
import sys
from pathlib import Path

EM_X86_64 = 62
ET_REL = 1
ET_EXEC = 2
SHT_SYMTAB = 2
SHN_UNDEF = 0
PT_INTERP = 3
PT_DYNAMIC = 2
PT_LOAD = 1
PF_X = 1
PT_GNU_STACK = 0x6474e551
ENTRY_MIN = 0xFFFFFFFF80000000


def fail(message):
    raise ValueError(message)


def section_headers(data, shoff, shentsize, shnum):
    if shentsize < 64:
        fail("ELF section header too short")
    out = []
    for idx in range(shnum):
        off = shoff + idx * shentsize
        if off + 64 > len(data):
            fail("section header outside file")
        out.append(struct.unpack_from("<IIQQQQIIQQ", data, off))
    return out


def section_bytes(data, sh, n):
    if n >= len(sh):
        fail(f"invalid section index {n}")
    sec = sh[n]
    off, size = sec[4], sec[5]
    if off + size > len(data):
        fail("section data outside file")
    return data[off:off + size]


def scan(path, expected_type):
    data = Path(path).read_bytes()
    if len(data) < 64 or data[:4] != b"\x7fELF":
        fail("not an ELF image")
    if data[4:7] != bytes((2, 1, 1)):
        fail("expected ELF64 little-endian v1")
    typ, machine, version = struct.unpack_from("<HHI", data, 16)
    if typ != expected_type or machine != EM_X86_64 or version != 1:
        fail(f"unexpected ELF type/machine/version: {typ}/{machine}/{version}")
    entry, phoff, shoff = struct.unpack_from("<QQQ", data, 24)
    phentsize, phnum, shentsize, shnum = struct.unpack_from("<HHHH", data, 54)
    sh = section_headers(data, shoff, shentsize, shnum)

    defined_main = False
    undefined = []
    for sec in sh:
        if sec[1] != SHT_SYMTAB:
            continue
        offset, size, entsize, str_index = sec[4], sec[5], sec[9], sec[6]
        if not entsize or entsize < 24 or size % entsize:
            fail("invalid symbol table")
        if offset + size > len(data):
            fail("symbol table outside file")
        names = section_bytes(data, sh, str_index)
        for i in range(size // entsize):
            off = offset + i * entsize
            name_off, info, other, shndx = struct.unpack_from("<IBBH", data, off)
            if name_off >= len(names):
                fail("symbol name offset out of range")
            name = names[name_off:].split(b"\0", 1)[0].decode("utf-8", "replace")
            if not name:
                continue
            if shndx == SHN_UNDEF and (info & 0x0F) != 3:  # ignore SECTION symbols
                undefined.append(name)
            if name == "main" and shndx != SHN_UNDEF:
                defined_main = True
    if not defined_main:
        fail("missing defined main entry symbol")
    if undefined:
        fail("undefined symbols: " + ", ".join(sorted(set(undefined))))

    if expected_type == ET_EXEC:
        if entry < ENTRY_MIN:
            fail("kernel entry is not a high-half virtual address")
        if phentsize < 56:
            fail("ELF program header too short")
        executable_segment = False
        for n in range(phnum):
            off = phoff + n * phentsize
            if off + 56 > len(data):
                fail("program header outside file")
            ptype, flags = struct.unpack_from("<II", data, off)
            if ptype in (PT_INTERP, PT_DYNAMIC):
                fail("host interpreter/dynamic loader is forbidden")
            if ptype == PT_GNU_STACK and (flags & PF_X):
                fail("executable stack requested")
            if ptype == PT_LOAD and (flags & PF_X):
                executable_segment = True
        if not executable_segment:
            fail("missing executable PT_LOAD segment")
        # Data must be exposed to Limine through a request scanning area.
        if b"\xae\xd1\xe7\x9d\xb3\xf4\xb8\xf6" not in data:
            fail("Limine requests start marker missing")

    print(f"ELF audit OK: {path} (type={typ}, entry=0x{entry:016x})")


def main():
    p = argparse.ArgumentParser()
    group = p.add_mutually_exclusive_group(required=True)
    group.add_argument("--object")
    group.add_argument("--kernel")
    args = p.parse_args()
    scan(args.object or args.kernel, ET_REL if args.object else ET_EXEC)


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, struct.error) as e:
        print(f"LiseOS ELF audit FAILED: {e}", file=sys.stderr)
        sys.exit(1)

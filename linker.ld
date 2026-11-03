/* LiseOS x86-64 bootstrap linker script.
 * Executable instructions are generated exclusively from kernel/main.ceru.
 *
 * Limine boot protocol base revision 3 tags are linker-emitted DATA, not
 * hand-written assembly or an extra-language kernel runtime.
 *
 * This first revision uses no Limine feature requests. A later revision
 * should move these descriptors into Cerune once section/layout control
 * and volatile/boot-protocol support exist.
 */
OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)
ENTRY(main)

PHDRS {
    text PT_LOAD FLAGS(5);
    rodata PT_LOAD FLAGS(4);
    data PT_LOAD FLAGS(6);
}

SECTIONS {
    . = 0xffffffff80000000;

    .text ALIGN(0x1000) : {
        *(.text .text.*)
    } :text

    .rodata ALIGN(0x1000) : {
        *(.rodata .rodata.*)
    } :rodata

    /* Dedicated 4 KiB page: avoid mixing RO and RW PT_LOAD permissions. */
    .limine_requests ALIGN(0x1000) : {
        /* Limine requests start marker. */
        QUAD(0xf6b8f4b39de7d1ae);
        QUAD(0xfab91a6940fcb9cf);
        QUAD(0x785c6ed015d3e316);
        QUAD(0x181e920a7852b9d9);

        /* Base revision 3 (no feature requests for M1a). */
        QUAD(0xf9562b2d5c95a6c8);
        QUAD(0x6a7b384944536bdc);
        QUAD(3);

        /* Limine requests end marker. */
        QUAD(0xadc0e0531bb10d03);
        QUAD(0x9572709f31764c62);
    } :data

    .data ALIGN(0x1000) : {
        *(.data .data.*)
    } :data

    .bss ALIGN(0x1000) (NOLOAD) : {
        *(COMMON)
        *(.bss .bss.*)
    } :data

    /DISCARD/ : {
        *(.comment)
        *(.eh_frame .eh_frame.*)
        *(.note.GNU-stack)
    }
}

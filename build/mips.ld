SECTIONS
{
    . = 0x9FC00000;
	. = ALIGN(4);
	.text       :
	{
      KEEP(*(.text.boot))
	  *(.text*)
	}

	. = ALIGN(4);
	.rodata  : { *(SORT_BY_ALIGNMENT(SORT_BY_NAME(.rodata*))) }

	. = ALIGN(4);
	.data  : { *(.data*) }

	. = .;
	_gp = ALIGN(16) + 0x7ff0;

	.got : {
	  __got_start = .;
	  *(.got)
	  __got_end = .;
	}

	.sdata  : { *(.sdata*) }

	. = ALIGN(4);
	__bss_start = .;
	.sbss (NOLOAD) : { *(.sbss*) }
	.bss (NOLOAD)  : { *(.bss*) . = ALIGN(4); }

	_end = .;
}
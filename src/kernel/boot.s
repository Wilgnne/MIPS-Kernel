.section ".text.boot"

.globl _start

_start:
    b		_start			# branch to _start

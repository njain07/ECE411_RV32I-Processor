riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -fno-builtin -nostdlib -nostartfiles -Tbaremetal_link.ld -S -O3 -o cache_test.s cache_test.c

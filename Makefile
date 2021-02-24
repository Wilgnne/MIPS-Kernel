TOOLCHAIN = /barebones-toolchain/cross/x86_64/bin/mips
# Compiler
CC = $(TOOLCHAIN)-gcc
# Linker
LD = $(TOOLCHAIN)-ld

# Compiler Flags
## -W -Wall -Wextra -ansi -pedantic
CC_FLAGS  = -c
## -ffreestanding -O2 
LD_FLAGS  = -nostdlib

# Location of the files
## Kernel source
KER_SRC    = src/kernel
## Kernel header
KER_HEAD   = include
## Common source
COMMON_SRC = src/common

# Build
## Dist Directory
DIST_DIR = dist
## Objects Directory
OBJ_DIR  = $(DIST_DIR)/objects

# List of files to compile
## Kernel files
KER_SOURCES    = $(wildcard $(KER_SRC)/*.c)
## Common files
COMMON_SOURCES = $(wildcard $(COMMON_SRC)/*.c)
## ASM files
ASM_SOURCES    = $(wildcard $(KER_SRC)/*.s)
## Headers files
HEADERS        = $(wildcard $(KER_HEAD)/*.h)

# Built Objects
## Kernel Objects
OBJECTS  = $(patsubst $(KER_SRC)/%.c, $(OBJ_DIR)/%.o, $(KER_SOURCES))
## Common Objects
OBJECTS += $(patsubst $(COMMON_SRC)/%.c, $(OBJ_DIR)/%.o, $(COMMON_SOURCES))
## ASM Objects
OBJECTS += $(patsubst $(KER_SRC)/%.s, $(OBJ_DIR)/%.o, $(ASM_SOURCES))

IMG_NAME = dist/kernel

build: $(OBJECTS)
	@ echo 'Building binary using GCC linker: $(IMG_NAME).elf'
	$(CC) -T build/mips.ld -o $(IMG_NAME).elf $(LD_FLAGS) $(OBJECTS)
	@ echo ' '

# Compile all .c in src/kernel
$(OBJ_DIR)/%.o: $(KER_SRC)/%.c
	@ mkdir -p $(@D)
	@ echo 'Building target using GCC compiler: $<'
	$(CC) $(CC_FLAGS) -I$(KER_SRC) -I$(KER_HEAD) -c $< -o $@
	@ echo ' '

# Compile all .s in src/kernel
$(OBJ_DIR)/%.o: $(KER_SRC)/%.s
	@ mkdir -p $(@D)
	@ echo 'Building target using GCC compiler: $<'
	$(CC) $(CC_FLAGS) -I$(KER_SRC) -c $< -o $@
	@ echo ' '

clean:
	@ rm -rf dist/

run: build
	qemu-system-mips -M malta -kernel $(IMG_NAME).elf -m 128 -nographic -no-reboot

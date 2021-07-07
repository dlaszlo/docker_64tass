# What is 64tass

64tass is cross assembler targeting the 65xx series of micro processors.

https://sourceforge.net/projects/tass64/

# How to use this image

Add _make.bat batch file (Windows) or _make.sh shell script (Linux) to your C64 project:

make.bat:
```
@echo off
set curr_dir=%~dp0
docker run --rm -v %curr_dir%:/source dlaszlo/64tass make %*
```
make.sh:
```
#!/bin/bash
docker run --user $(id -u):$(id -g) --rm -v "$PWD:/source" dlaszlo/64tass make $@
```

Add a Makefile to your C64 project, for example:

```
PROGRAM = dots
LINKING = 0

all: $(PROGRAM).prg

$(PROGRAM).prg: $(PROGRAM).tmp
	b2 -c 1000 $<
	mv $<.b2 $@

tables.asm:
	node tables.js

$(PROGRAM).tmp: $(PROGRAM).asm tables.asm
	64tass -C -a $< -o $@ -L $(PROGRAM).lst --verbose-list -l $(PROGRAM).sym -D LINKING=$(LINKING)

.INTERMEDIATE: $(PROGRAM).tmp

.PHONY: all clean

clean:
	rm -f tables.asm $(PROGRAM).prg $(PROGRAM).tmp $(PROGRAM).lst $(PROGRAM).sym
```

Compile your project:

```
.\_make.bat clean all LINKING=0
```

You can use the following utilities:

- 64tass (v1.56.2625): https://sourceforge.net/projects/tass64/
- ByteBoozer 2: https://csdb.dk/release/?id=145031
- Exomizer 3.1.0: https://csdb.dk/release/?id=198340
- OpenJDK11, Python3, NodeJS, NPM

Dockerfile:

https://github.com/dlaszlo/docker_64tass



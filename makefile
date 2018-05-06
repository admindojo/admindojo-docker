SHELL := /bin/bash # Use bash syntax
DIR := ${CURDIR}
NEWDIR := $$PATH:$(DIR)
#Make Function Documentation
doku: game.sh
	rm -f Functions.md
	~/programming/tools/shdoc/shdoc  < game.sh  >> Functions.md

install:

	@echo Make game executable
	@chmod u+x game.sh
	@chmod u+x helper.sh
	@echo "PATH: $$PATH
	./setup.sh


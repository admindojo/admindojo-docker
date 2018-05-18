SHELL := /bin/bash # Use bash syntax
DIR := ${CURDIR}
NEWDIR := $$PATH:$(DIR)
#Make Function Documentation
doku: admindojo.sh
	rm -f Functions.md
	~/programming/tools/shdoc/shdoc  < admindojo.sh  >> Functions.md

install:

	@echo Make admindojo executable
	@chmod u+x admindojo.sh
	@chmod u+x helper.sh
	@echo "PATH: $$PATH
	./setup.sh


SHELL := /bin/bash # Use bash syntax

#Make Function Documentation
doku: tutor.sh
	rm -f Functions.md
	~/programming/tools/shdoc/shdoc  < tutor.sh  >> Functions.md

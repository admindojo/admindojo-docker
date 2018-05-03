SHELL := /bin/bash # Use bash syntax

#Make Function Documentation
doku: game.sh
	rm -f Functions.md
	~/programming/tools/shdoc/shdoc  < game.sh  >> Functions.md

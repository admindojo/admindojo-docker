SHELL := /bin/bash # Use bash syntax

#Make Function Documentation
doku: test.sh
	#rm -f Functions.md
	~/programming/tools/shdoc/shdoc  < test.sh  >> Functions.md

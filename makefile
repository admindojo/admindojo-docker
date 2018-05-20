SHELL := /bin/bash # Use bash syntax
#Make Function Documentation
doku: admindojo.sh
	rm -f Functions.md
	~/programming/tools/shdoc/shdoc  < admindojo.sh  >> Functions.md

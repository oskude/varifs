.PHONY: test

target = /tmp/varifstest
source = ${PWD}

test:
	mkdir -p "$(target)"
	../varifs "$(target)" -o root="$(source)"
	cat .varifs
	cat .varifs.secret
	cat testfile
	cat "$(target)/testfile"
	file testlink
	file "$(target)/testlink"
	fusermount -u "$(target)"

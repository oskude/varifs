.PHONY: info test pkg

info:
	# available targets:
	# test ~ run a simple test
	# pkg ~ create archlinux package

test:
	cd example && make

pkg:
	cd distro/archlinux && \
	rm *.pkg.tar.* ;\
	makepkg

install:
	mkdir -p debian/lxcm/usr/bin/
	mkdir -p debian/lxcm/usr/share/doc/lxcm/
	install lxcm debian/lxcm/usr/bin/
	install docs/* debian/lxcm/usr/share/doc/lxcm/


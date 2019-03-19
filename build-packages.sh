#!/bin/bash

# Build *.tar.gz and *.deb packages for lxcm.

function build-deb-package {    
    chown -R root:root build
    dpkg-deb --build build
}

if [[ "$1" != "" ]]
then
    cmd="$1"
    shift
    "$cmd" "$@"
    exit
fi

read -p "Please enter the product release number: " rel

(
    cd ..
    tar --owner root --group root -cvf lxcm/dist/lxcm-$rel.tar.gz --exclude dist --exclude build-packages.sh lxcm/*
)

mkdir -p build/usr/bin/ build/usr/share/doc/lxcm/ build/DEBIAN
cp lxcm build/usr/bin/
cp DEBIAN/control DEBIAN/postinst build/DEBIAN
cp README.md docs/* build/usr/share/doc/lxcm/
cp DEBIAN/copyright build/usr/share/doc/lxcm/copyright
gzip < DEBIAN/changelog > build/usr/share/doc/lxcm/changelog.Debian.gz

fakeroot "$0" build-deb-package

mv build.deb dist/lxcm-$rel.deb
rm -r build


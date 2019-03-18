#!/bin/bash

# Build *.tar.gz and *.deb packages for lxcm.

read -p "Please enter the product release number: " rel

(
    cd ..
    tar -cvf lxcm/dist/lxcm-$rel.tar.gz --exclude dist --exclude build-packages.sh lxcm/*
)

mkdir -p build/usr/bin/ build/usr/share/doc/lxcm/ build/DEBIAN
cp lxcm build/usr/bin/
cp docs/* build/usr/share/doc/lxcm/

cat > build/DEBIAN/control << EOF
Package: lxcm
Version: $rel
Section: main
Priority: optional
Depends: acl, squashfs-tools, lxc, unionfs-fuse, bindfs, whiptail
Recommends: bash-completion, lxc-templates, yum, vim
Maintainer: Ian Walton
Architecture: all
Description: Container and firewall manager.
EOF

cat > build/DEBIAN/postinst << EOF
#!/bin/bash
/usr/bin/lxcm install postinst
EOF
chmod +x build/DEBIAN/postinst

dpkg-deb --build build
mv build.deb dist/lxcm-$rel.deb
rm -r build


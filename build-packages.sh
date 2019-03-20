#!/bin/bash

# Build *.tar.gz and *.deb packages for lxcm.

read -p "Please enter the product release number: " rel

(
    cd ..
    if [[ "$1" != "ppa" ]]
    then
        tar --owner root --group root -cvf lxcm/dist/lxcm-$rel.tar.gz --exclude dist --exclude build-packages.sh lxcm/*
    fi
)

mkdir -p srcbuild srcbuild/docs srcbuild/debian
cp -r docs Makefile srcbuild/
cp README.md srcbuild/docs/
cp lxcm srcbuild/
cp -r debian srcbuild/

(
    mkdir tmp
    mv srcbuild tmp
    cd tmp/srcbuild
    if [[ "$1" == "ppa" ]]
    then
        debuild -sa -S
    else
        debuild -sa
    fi
    cd ..
    rm -r srcbuild
    mv * ../dist/
    cd ..
    rm -r tmp
)



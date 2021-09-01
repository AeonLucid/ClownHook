#!/bin/sh

cd submodules/unicorn

if [ "$1" == clean ]; then
    rm -f ../../lib/libunicorn_macOS.a ../../lib/libunicorn_iOS.a
    make clean
    exit 0
fi

# iOS build
if [ ! -f "../../lib/libunicorn_iOS.a" ]; then
    make clean

    UNICORN_ARCHS="aarch64" \
    UNICORN_SHARED=no \
    UNICORN_STATIC=yes make

    mkdir -p ../../lib
    mv libunicorn.a ../../lib/libunicorn_iOS.a
fi

# iOS build
if [ ! -f "../../lib/libunicorn_macOS.a" ]; then
    make clean

    UNICORN_ARCHS="aarch64" \
    UNICORN_SHARED=no \
    UNICORN_STATIC=yes ./make.sh macos-universal-no

    mkdir -p ../../lib
    mv libunicorn.a ../../lib/libunicorn_macOS.a
fi
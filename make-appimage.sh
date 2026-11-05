#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"

export ICON=./AppDir/share/pixmaps/devin-desktop.png
export DESKTOP=./AppDir/share/applications/devin-desktop.desktop

quick-sharun ./AppDir/bin/* /usr/lib/libnss_nis.so* /usr/lib/libnsl.so* /usr/lib/libnss_mdns*_minimal.so*
quick-sharun --make-appimage
quick-sharun --test ./dist/*.AppImage

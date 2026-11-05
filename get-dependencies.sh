#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm patchelf libnss_nis nss-mdns nss

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Getting binary..."
echo "---------------------------------------------------------------"

case "$ARCH" in
	x86_64)  farch=amd64;;
	# aarch64) farch=arm64;;
esac

BASE="https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt"
read -r VERSION FILE < <(
  curl -fsSL "$BASE/dists/stable/main/binary-$farch/Packages.gz" | gzip -dc | awk '
    /^Version:/  {v=$2; sub(/-.*/, "", v)}
    /^Filename:/ {print v, $2; exit}
  '
)

curl -sSfL --retry 30 --retry-connrefused "$BASE/$FILE" -o /tmp/temp.deb
echo "$VERSION" > ~/version

echo "Preparing AppDir..."
mkdir -p ./AppDir/bin
bsdtar -xOf /tmp/temp.deb data.tar.xz | bsdtar -xf - --strip-components=2 -C ./AppDir/

mv -f ./AppDir/share/devin-desktop/* ./AppDir/bin/
rm -rf ./AppDir/share/devin-desktop

rm -rf ./AppDir/bin/bin

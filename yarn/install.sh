#!/bin/bash
#
# install nodejs
VERSION=v18.15.0
DISTRO=linux-x64

wget -O node-${VERSION}-${DISTRO}.tar.xz https://nodejs.org/dist/${VERSION}/node-${VERSION}-${DISTRO}.tar.xz
sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo -e "# Nodejs\nVERSION=${VERSION}\nDISTRO=${DISTRO}\nexport PATH=/usr/local/lib/nodejs/node-\$VERSION-\$DISTRO/bin:\$PATH" >> ${SCRIPT_DIR}/../zsh/zshrc.symlink

rm node-${VERSION}-${DISTRO}.tar.xz


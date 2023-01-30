#!/bin/bash

echo "====================="
echo "start to build kata agent"

set -x

export ARCH="$(uname -m)"
if [ "$ARCH" = "ppc64le" -o "$ARCH" = "s390x" ]; then export LIBC=gnu; else export LIBC=musl; fi
[ "${ARCH}" == "ppc64le" ] && export ARCH=powerpc64le
rustup target add "${ARCH}-unknown-linux-${LIBC}"

make -C kata-containers/src/agent

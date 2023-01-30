#!/bin/bash

set -x

export distro="centos" # example
export ROOTFS_DIR="$(realpath kata-containers/tools/osbuilder/rootfs-builder/rootfs)"
sudo rm -rf "${ROOTFS_DIR}"
pushd kata-containers/tools/osbuilder/rootfs-builder
script -fec 'sudo -E AGENT_INIT=yes USE_DOCKER=true SECCOMP=no ./rootfs.sh "${distro}"'
popd

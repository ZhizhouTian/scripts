#!/bin/bash

set -x

export distro="centos" # example
export ROOTFS_DIR="$(realpath kata-containers/tools/osbuilder/rootfs-builder/rootfs)"
sudo rm -rf "${ROOTFS_DIR}"
pushd kata-containers/tools/osbuilder/rootfs-builder
sudo -E USE_DOCKER=true ./rootfs.sh ${distro}
popd

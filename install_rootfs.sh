#!/bin/bash

set -x

PWD=$(pwd)
ROOTFS_DIR="$(realpath kata-containers/tools/osbuilder/rootfs-builder/rootfs)"

#module_dir=${ROOTFS_DIR}/lib/modules/519.2-nvidia-gpu/
#mkdir -p ${module_dir}
#
#sudo install -o root -g root -m 0440 "${PWD}/scripts/nvidia.ko" ${module_dir}
#sudo install -o root -g root -m 0440 "${PWD}/scripts/nvidia-uvm.ko" ${module_dir}
#
## TODO
#tools="lspci lsmod modprobe modinfo insmod rmmod nvidia-smi"
#for tool in ${tools}; do
#	sudo install -o root -g root -m 0740 "$(which ${tool})" "${ROOTFS_DIR}/usr/bin";
#done
#
#sos="libcrypto.so.1.1 libpci.so.3 libkmod.so.2 libcuda.so libnvidia-ml.so"
#for so in ${sos}; do
#	sudo install -o root -g root -m 0740 "/lib64/${so}" "${ROOTFS_DIR}/lib64";
#done

sudo install -o root -g root -m 0550 -t "${ROOTFS_DIR}/usr/bin" "${ROOTFS_DIR}/../../../../src/agent/target/x86_64-unknown-linux-musl/release/kata-agent"
sudo install -o root -g root -m 0440 "${ROOTFS_DIR}/../../../../src/agent/kata-agent.service" "${ROOTFS_DIR}/usr/lib/systemd/system/"
sudo install -o root -g root -m 0440 "${ROOTFS_DIR}/../../../../src/agent/kata-containers.target" "${ROOTFS_DIR}/usr/lib/systemd/system/"

pushd  kata-containers/tools/osbuilder/image-builder
script -fec "sudo -E USE_DOCKER=true ./image_builder.sh ${ROOTFS_DIR}"
popd

pushd kata-containers/tools/osbuilder/image-builder
commit="$(git log --format=%h -1 HEAD)"
date="$(date +%Y-%m-%d-%T.%N%z)"
image="kata-containers-${date}-${commit}"
sudo install -o root -g root -m 0640 -D kata-containers.img "/usr/share/kata-containers/${image}"
(cd /usr/share/kata-containers && sudo ln -sf "$image" kata-containers.img)
popd

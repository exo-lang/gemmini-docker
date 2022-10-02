#!/bin/bash
set -e

apt-get -y update
apt-get -y upgrade
apt-get install -y build-essential bison flex software-properties-common curl \
                   libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev vim default-jdk default-jre \
                   texinfo gengetopt libexpat1-dev libusb-dev libncurses5-dev cmake git \
                   device-tree-compiler python gawk autoconf

# Install chipyard
git clone https://github.com/ucb-bar/chipyard.git
cd chipyard
git checkout 76b747dc846706e898090960b9bcb2c3105e9b81

./scripts/build-toolchains.sh esp-tools --ignore-qemu
cd toolchains/esp-tools/riscv-isa-sim
patch -p1 < ~/chipyard.diff
cd -
./scripts/build-toolchains.sh esp-tools --ignore-qemu

source env.sh

git submodule update --init generators/gemmini
cd generators/gemmini
git checkout 138e2c3a20f326f3c3510cdb934578de05f8192e
git submodule update --init
cd -

git submodule update --init toolchains/esp-tools/riscv-isa-sim
cd toolchains/esp-tools/riscv-isa-sim
git stash
git checkout 34741e07bc6b56f1762ce579537948d58e28cd5a
cd build
rm -rf *
../configure --prefix=$RISCV
make && make install
cd ../../../../

cd generators/gemmini/software/gemmini-rocc-tests
git submodule update --init --recursive
./build.sh

cd ..
rm -rf gemmini-rocc-tests
git clone https://github.com/exo-lang/gemmini-rocc-tests.git
cd gemmini-rocc-tests/
git checkout exo
git submodule update --init --recursive
./build.sh

cd build/bareMetalC
spike --extension=gemmini tiled_matmul_ws-baremetal
spike --extension=gemmini conv-baremetal

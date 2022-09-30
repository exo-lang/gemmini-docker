apt update
apt upgrade

apt-get install -y build-essential bison flex software-properties-common curl
apt-get install -y libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev vim default-jdk default-jre
# install sbt: https://www.scala-sbt.org/release/docs/Installing-sbt-on-Linux.html#Ubuntu+and+other+Debian-based+distributions
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
apt-get update
apt-get install -y sbt
apt-get install -y texinfo gengetopt
apt-get install -y libexpat1-dev libusb-dev libncurses5-dev cmake
# deps for poky
apt-get install -y python3.9 patch diffstat texi2html texinfo subversion chrpath wget
# deps for qemu
apt-get install -y libgtk-3-dev gettext
# deps for firemarshal
apt-get install -y python3-pip python3.9-dev rsync libguestfs-tools expat ctags
# install DTC
apt-get install -y device-tree-compiler
apt-get install -y python
# install git >= 2.17
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install git -y


git clone https://github.com/ucb-bar/chipyard.git
cd chipyard
git checkout 76b747dc846706e898090960b9bcb2c3105e9b81

./scripts/init-submodules-no-riscv-tools.sh
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


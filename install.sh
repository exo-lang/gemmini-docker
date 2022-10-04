git clone --recursive --branch exo https://github.com/exo-lang/gemmini-rocc-tests.git
cd gemmini-rocc-tests/

./build.sh

cd build/bareMetalC
spike --extension=gemmini tiled_matmul_ws-baremetal
spike --extension=gemmini tiled_matmul_ws-2-baremetal
spike --extension=gemmini tiled_matmul_ws-3-baremetal
spike --extension=gemmini tiled_matmul_ws-4-baremetal
spike --extension=gemmini tiled_matmul_ws-5-baremetal
spike --extension=gemmini tiled_matmul_ws-6-baremetal
spike --extension=gemmini conv-baremetal
spike --extension=gemmini conv-2-baremetal
spike --extension=gemmini conv-3-baremetal

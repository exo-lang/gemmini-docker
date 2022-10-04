FROM ubuntu:20.04

WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=US

RUN apt-get -y update && \
    apt-get install -y build-essential bison flex software-properties-common curl \
      libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev vim default-jdk default-jre \
      texinfo gengetopt libexpat1-dev libusb-dev libncurses5-dev cmake git \
      device-tree-compiler python gawk autoconf

ENV RISCV=/opt/riscv

ARG CHIPYARD_HASH=76b747dc846706e898090960b9bcb2c3105e9b81
ARG GEMMINI_HASH=138e2c3a20f326f3c3510cdb934578de05f8192e
ARG RISCV_ISA_SIM_HASH=34741e07bc6b56f1762ce579537948d58e28cd5a

RUN git clone https://github.com/ucb-bar/chipyard.git && \
    cd chipyard && \
    git checkout "$CHIPYARD_HASH" && \
    git submodule update --init generators/gemmini toolchains/esp-tools/riscv-isa-sim && \
    git -C toolchains/esp-tools/riscv-isa-sim checkout "$RISCV_ISA_SIM_HASH" && \
    git -C generators/gemmini checkout "$GEMMINI_HASH" && \
    git add . && \
    ./scripts/build-toolchains.sh esp-tools --prefix "$RISCV" --ignore-qemu && \
    cd .. && \
    rm -rf chipyard

ENV PATH $RISCV/bin:$PATH
ENV LD_LIBRARY_PATH $RISCV/lib:$LD_LIBRARY_PATH

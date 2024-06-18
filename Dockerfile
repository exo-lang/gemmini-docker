FROM ubuntu:22.04

WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=US

SHELL ["/bin/bash", "-c"]

RUN apt-get -y update && \
    apt-get install -y wget git make autoconf gcc lsb-release

RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b -p conda

ENV PATH /root/conda/bin:$PATH

RUN conda install -y -n base conda-libmamba-solver && \
    conda config --set solver libmamba && \
    conda install -y -n base conda-lock==1.4.0

RUN git clone https://github.com/ucb-bar/chipyard.git && \
    cd chipyard && \
    git checkout 1.9.1 && \
    ./build-setup.sh riscv-tools -s 4 -s 5 -s 6 -s 7 -s 8 -s 9

RUN cd chipyard &&\
    source $(conda info --base)/etc/profile.d/conda.sh &&\
    source env.sh &&\
    cd generators/gemmini && \
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" && \
    git fetch && git checkout v0.7.1 && \
    git submodule update --init --recursive && \
    make -C software/libgemmini install && \
    ./scripts/build-spike.sh

ENV PATH $RISCV/bin:$PATH
ENV LD_LIBRARY_PATH $RISCV/lib:$LD_LIBRARY_PATH

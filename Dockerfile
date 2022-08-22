FROM debian:bullseye as toolchain

ARG binutils=2.39
ARG gcc=12.2.0

LABEL maintainer="Wouter van der Wal <me@wjtje.dev>"
WORKDIR /

# Install all the required packages
RUN \
    apt update && \
    apt install -y binutils build-essential cmake gcc git lbzip2 libgmp-dev libmpc-dev libmpfr-dev libpng-dev make texinfo wget xz-utils

# Download and build binutils
RUN \
    echo "Installing binutils ${binutils}" && \
    wget https://ftp.gnu.org/gnu/binutils/binutils-${binutils}.tar.bz2 && \
    tar -xf binutils*.tar.bz2 && \
    mkdir /build-binutils && cd /build-binutils && \
    ../binutils-${binutils}/configure --target=sh3eb-elf --prefix=/usr/local/cross --disable-nls --disable-werror && \
    make -j$(nproc) && \
    make install

# Download and build gcc
RUN \
    echo "Installing gcc ${gcc}" && \
    wget https://ftp.gnu.org/gnu/gcc/gcc-${gcc}/gcc-${gcc}.tar.xz && \
    tar -xf gcc*.tar.xz && \
    mkdir /build-gcc && cd /build-gcc && \
    ../gcc-${gcc}/configure --target=sh3eb-elf --prefix=/usr/local/cross --enable-languages=c,c++ \
    --with-newlib --without-headers --disable-hosted-libstdcxx --disable-nls --disable-shared --disable-multilib && \
    make all-gcc -j$(nproc) && \
    make install-gcc && \
    make all-target-libgcc -j$(nproc) && \
    make install-target-libgcc

# Download and build mkg3a
RUN \
    git clone https://gitlab.com/taricorp/mkg3a.git && \
    cd mkg3a && \
    cmake . && \
    make -j$(nproc) && \
    make install

# Download libfxcg
FROM debian:bullseye-slim

ARG fxcg=0.5.2

COPY --from=toolchain /usr/local /usr/local
WORKDIR /usr/src
ENV PATH=$PATH:/usr/local/cross/bin

RUN \
    apt update && \
    apt install -y git curl make libmpc-dev libpng-dev

# Compile libfxcg
RUN \
    git clone https://github.com/Jonimoose/libfxcg.git && \
    cd libfxcg && \
    git checkout tags/v${fxcg} && \
    sed -i 's/sh3eb-elf-/\/usr\/local\/cross\/bin\/sh3eb-elf-/g' toolchain/prizm_rules && \
    make

# Add missing header files
COPY include /usr/src/libfxcg/include

ENV FXCGSDK=/usr/src/libfxcg

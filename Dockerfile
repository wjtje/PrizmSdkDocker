FROM debian:bullseye

RUN \
    # Install all the required packages
    apt update && \
    apt install -y binutils build-essential cmake gcc git lbzip2 libgmp-dev libmpc-dev libmpfr-dev libpng-dev make texinfo wget xz-utils && \
    # Make basic folder structure
    cd /usr && \
    chmod a+rw src && \
    mkdir /usr/local/cross && \
    cd src && \
    mkdir build-gcc build-binutils && \
    # Download binutils
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.bz2 && \
    tar -xf binutils*.tar.bz2 && \
    rm binutils*.tar.bz2 && \
    mv binutils* binutils && \
    # Download gcc
    wget https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz && \
    tar -xf gcc*.tar.xz && \
    rm gcc*.tar.xz && \
    mv gcc* gcc && \
    # Compile binutls
    cd build-binutils && \
    ../binutils/./configure --target=sh3eb-elf --prefix=/usr/local/cross --disable-nls --disable-werror && \
    make -j6 && \
    make install && \
    # Compile gcc
    export PATH=$PATH:/usr/local/cross/bin && \
    cd /usr/src/build-gcc && \
    ../gcc/./configure --target=sh3eb-elf --prefix=/usr/local/cross -enable-sjlj-exceptions --disable-hosted-libstdcxx --with-gnu-as --with-gnu-ld --enable-languages=c,c++ --disable-nls --disable-tls --disable-libssp --disable-threads --disable-shared --disable-__cxa_atexit && \
    make all-gcc -j6 && \
    make install-gcc && \
    make all-target-libgcc -j6 && \
    make install-target-libgcc && \
    # Compile mkg3a
    cd /usr/src && \
    wget https://gitlab.com/taricorp/mkg3a/-/archive/master/mkg3a-master.tar.gz && \
    tar -xf mkg3a*.tar.gz && \
    rm mkg3a*.tar.gz && \
    mv mkg3a* mkg3a && \
    cd mkg3a && \
    cmake . && \
    make && \
    make install && \
    # Cleanup
    cd /usr/src && \
    rm -rf * && \
    # Compile libfxcg
    git clone https://github.com/Jonimoose/libfxcg.git && \
    cd libfxcg && \
    sed -i 's/sh3eb-elf-/\/usr\/local\/cross\/bin\/sh3eb-elf-/g' toolchain/prizm_rules

ENV PATH=$PATH:/usr/local/cross/bin
ENV FXCGSDK=/usr/src/libfxcg

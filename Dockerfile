FROM ubuntu:bionic

COPY etc/qemu-arm-static /usr/bin/
COPY etc/qemu-aarch64-static /usr/bin/

RUN apt-get update && \
    apt-get install -y build-essential \
        zlib1g-dev unzip \
        automake autoconf libtool \
        git sox wget subversion \
        python2.7 python3 \
        libatlas-dev libatlas3-base

RUN ln -s /usr/bin/python2.7 /usr/bin/python2

RUN cd / && git clone https://github.com/kaldi-asr/kaldi.git

RUN cd /kaldi/tools && \
    make

RUN cd /kaldi/src && \
    ./configure --shared && \
    make depend -j 8 && \
    make -j 8

COPY etc/files-to-keep.txt /
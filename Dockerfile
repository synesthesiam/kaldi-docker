ARG BUILD_FROM
FROM $BUILD_FROM

COPY etc/qemu-arm-static /usr/bin/
COPY etc/qemu-aarch64-static /usr/bin/

RUN apt-get update && \
    apt-get install -y build-essential \
        zlib1g-dev unzip \
        automake autoconf libtool \
        git sox wget subversion \
        python2.7 python3 \
        libatlas-base-dev libatlas3-base

RUN ln -sf /usr/bin/python2.7 /usr/bin/python2

RUN cd / && git clone https://github.com/kaldi-asr/kaldi.git

RUN cd /kaldi/tools && \
    make

RUN cd /kaldi/src && \
    ./configure --shared --mathlib=ATLAS

RUN if [ "$(uname -m)" = "aarch64" ]; then sed -i 's/-msse -msse2/-ftree-vectorize/g' /kaldi/src/kaldi.mk ; fi

RUN cd /kaldi/src && \
    make depend -j 8 && \
    make -j 8

COPY etc/files-to-keep.txt /

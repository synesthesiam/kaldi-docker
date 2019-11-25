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
        libatlas-base-dev libatlas3-base \
        gfortran

RUN ln -sf /usr/bin/python2.7 /usr/bin/python2

COPY download/kaldi-master.tar.gz /
RUN cd / && tar -xvf kaldi-master.tar.gz && \
    mv /kaldi-master /kaldi

RUN cd /kaldi/tools && \
    make

RUN touch /kaldi.env

RUN if [ -f '/usr/lib/arm-linux-gnueabihf/libatlas.so' ]; then echo export ATLASLIBDIR='/usr/lib/arm-linux-gnueabihf' > /kaldi.sh; fi

RUN if [ -f '/usr/lib/aarch64-linux-gnu/libatlas.so' ]; then echo export ATLASLIBDIR='/usr/lib/aarch64-linux-gnu' > /kaldi.sh; fi

RUN echo cd /kaldi/src >> /kaldi.sh && \
    echo ./configure --shared --mathlib=ATLAS >> /kaldi.sh && \
    sh /kaldi.sh

RUN if [ "$(uname -m)" = "aarch64" ]; then sed -i 's/-msse -msse2/-ftree-vectorize/g' /kaldi/src/kaldi.mk ; fi

RUN cd /kaldi/src && \
    make depend -j 8 && \
    make -j 8

RUN strip --strip-all /kaldi/src/lib/*.so*
RUN strip --strip-all /kaldi/tools/openfst/lib/*.so*

COPY etc/files-to-keep.txt /

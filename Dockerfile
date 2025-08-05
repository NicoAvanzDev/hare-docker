FROM ubuntu:22.04 AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    wget \
    git && \
    rm -rf /var/lib/apt/lists/*

# Install QBE

RUN wget https://c9x.me/compile/release/qbe-1.2.tar.xz

RUN tar -xf qbe-1.2.tar.xz && \
    rm qbe-1.2.tar.xz && \
    cd qbe-1.2 && \
    make && \
    make install

# Install scdoc

RUN git clone https://git.sr.ht/~sircmpwn/scdoc

RUN cd scdoc && \
    make && \
    make install

# Build and install the harec compiler
RUN git clone --branch 0.25.2 --depth 1 https://git.sr.ht/~sircmpwn/harec

RUN cd harec && \
    cp configs/linux.mk config.mk && \
    make && \
    make install

# Build and install the harec standard library

RUN git clone --branch 0.25.2 --depth 1 https://git.sr.ht/~sircmpwn/hare

RUN cd hare && \
    cp configs/linux.mk config.mk && \
    make && \
    make install


WORKDIR /src
ENTRYPOINT [ "hare" ]
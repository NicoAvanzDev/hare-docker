# 🐇 Hare Programming Language Docker Image

A minimal Docker image for compiling and running [Hare](https://harelang.org/) programs, built from source with QBE, `scdoc`, `harec`, and the Hare standard library.

---

## 📦 Included

This image includes:

- 🐧 Ubuntu 22.04 base
- ⚙️ [QBE 1.2](https://c9x.me/compile/)
- 📄 [`scdoc`](https://sr.ht/~sircmpwn/scdoc/)
- 🔨 [`harec` compiler v0.25.2](https://sr.ht/~sircmpwn/harec/)
- 📚 Hare standard library v0.25.2

---

## 🚀 Usage

### Run Hare REPL or commands interactively

```bash
docker run -it --rm -v "$(pwd):/src" -w /src nicoavanzdev/hare run
```

### Compile and run a local `.ha` file

```bash
docker run -it --rm -v "$(pwd):/src" -w /src nicoavanzdev/hare run hello.ha
```

---

## 🛠️ Example: `hello.ha`

```hare
use fmt;

export fn main() void = {
    fmt::println("Hello, world!")!;
};
```

```bash
docker run -it --rm -v "$(pwd):/src" -w /src nicoavanzdev/hare run hello.ha
```

---

## 📁 Volume Mount

The working directory inside the container is `/src`. Mount your code like so:

```bash
-v "$(pwd)":/src -w /src
```

---

## 📌 Tags

- `latest` — Hare v0.25.2 with QBE v1.2

---

## 🧪 Test

Check the Hare tool is available:

```bash
docker run --rm nicoavanzdev/hare version
```

---

## 🔧 Built With

This image is built using the following stack:

- `qbe` 1.2
- `scdoc` from source
- `harec` and the Hare standard library from sourcehut

All components are built using `make` and installed with `make install`.

---

## 🧾 License

This image includes third-party software released under their respective licenses (Hare: GPLv3). The Dockerfile and packaging are MIT licensed.

---

## 📄 Dockerfile

<details>
<summary>Click to view full Dockerfile</summary>

```dockerfile
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

# Build and install harec
RUN git clone --branch 0.25.2 --depth 1 https://git.sr.ht/~sircmpwn/harec
RUN cd harec && \
    cp configs/linux.mk config.mk && \
    make && \
    make install

# Build and install standard library
RUN git clone --branch 0.25.2 --depth 1 https://git.sr.ht/~sircmpwn/hare
RUN cd hare && \
    cp configs/linux.mk config.mk && \
    make && \
    make install

WORKDIR /src
ENTRYPOINT ["hare"]
```

</details>

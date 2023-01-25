FROM ubuntu:22.04

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install git wget -y

# Install rust

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.66.1 \
    rustArch='x86_64-unknown-linux-gnu' \
    rustupSha256='5cc9ffd1026e82e7fb2eec2121ad71f4b0f044e88bca39207b3f6b769aaa799c'

RUN url="https://static.rust-lang.org/rustup/archive/1.25.1/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# Substrate's wasm builder requires a nightly release of rust 
# https://github.com/paritytech/substrate/blob/cb4f2491b00af7d7817f3a54209c26b20faa1f51/utils/wasm-builder/src/prerequisites.rs
# ( seems like this will be fixed one of these days: https://github.com/paritytech/substrate/issues/1252 )
RUN rustup install nightly-2022-11-15 
RUN rustup target add wasm32-unknown-unknown --toolchain nightly-2022-11-15

# Extra substrate/tfchain requirements
RUN apt-get install -y librocksdb-dev libclang-dev  clang lldb lld build-essential protobuf-compiler

ADD conf.sh /

COPY --from=rustbuilder /bin/zinit /bin/zinit


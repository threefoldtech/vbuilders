FROM rustbuilder

# TODO double check if rocksdb-dev lld lldb are really needed
RUN apk add protoc g++ make clang-dev linux-headers rocksdb-dev lld lldb 

# Substrate's wasm builder requires a nightly release of rust 
# https://github.com/paritytech/substrate/blob/cb4f2491b00af7d7817f3a54209c26b20faa1f51/utils/wasm-builder/src/prerequisites.rs
# ( seems like this will be fixed one of these days: https://github.com/paritytech/substrate/issues/1252 )
RUN rustup install nightly-2022-11-15 
RUN rustup target add wasm32-unknown-unknown --toolchain nightly-2022-11-15

ADD conf.sh /


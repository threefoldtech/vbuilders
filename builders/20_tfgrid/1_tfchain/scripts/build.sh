#!/bin/sh

set -ex

mkdir -p /code/threefoldtech/
cd /code/threefoldtech/ 
rm -rf *
mkdir tfchain
cd tfchain


wget -c https://github.com/threefoldtech/tfchain/archive/refs/tags/${TFCHAIN_VERSION}  -O - | tar -strip-components=1 -xzf --strip-components=1 - -C ./

cd substrate-node
cargo build --release
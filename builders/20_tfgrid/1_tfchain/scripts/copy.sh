#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/ubuntu/tfchain/bin
cp /code/threefoldtech/tfchain/substrate-node/target/release/tfchain /myhost/ubuntu/tfchain/bin/

echo " ** COPY DONE"




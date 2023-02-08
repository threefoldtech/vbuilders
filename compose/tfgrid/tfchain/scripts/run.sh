#!/bin/sh
set -e

/bin/tfchain \
    --node-key baad0200d185d1ec4434b197f78a1bcb74aa9d8ee9c591c55390ea910b505f8b \
    --base-path /storage
    --chain /etc/chainspecs/dev/chainSpecRaw.json \
    --port 30333 \
    --bootnodes /ip4/185.206.122.7/tcp/30333/ws/p2p/12D3KooWRdfuKqX8hULMZz521gdqZB2TXJjfrJE5FV71WiuAUrpk
    --rpc-cors all \
    --prometheus-external \
    --ws-external \
    --ws-max-connections=148576 \
    --pruning archive \
    --rpc-methods=Safe \
    --rpc-external
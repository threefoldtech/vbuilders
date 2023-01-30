#!/bin/sh

set -ex

cd /app
rm -rf *


mkdir /app/gridproxy

wget -cnv https://github.com/threefoldtech//tfgridclient_proxy/archive/refs/tags/${GRIDPROXY_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C /app/gridproxy
rm /tmp/src.tar.gz

YGGDRASIL_VERSION=$(awk -F= '/YGG_VERS/ { print $2}' /app/gridproxy/Dockerfile)
mkdir /app/yggdrasil
cd /app/yggdrasil
git clone --depth 1 --branch $YGGDRASIL_VERSION https://github.com/yggdrasil-network/yggdrasil-go.git .
./build && go build -o genkeys cmd/genkeys/main.go

cd /app/gridproxy
CGO_ENABLED=0 GOOS=linux go build -ldflags "-w -s -X main.GitCommit=$GRIDPROXY_VERSION -extldflags '-static'" -o server cmds/proxy_server/main.go 



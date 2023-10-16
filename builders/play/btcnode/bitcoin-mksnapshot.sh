#!/bin/bash

echo "[+] setting up environment"

export backend_host="2001:728:1000:402:70b4:a3ff:fe89:bf13"
export backend_port="9900"
export backend_name="604-22888-zdb1"
export backend_pass="blablabla"

export ZFLIST_MNT=/tmp/flistworkdir
export ZFLIST_PROGRESS=1
export ZFLIST_BACKEND=$(printf '{"host": "%s", "port": %s, "namespace": "%s", "password": "%s"}' \
    $backend_host $backend_port $backend_name $backend_pass)

export dataroot=/root/.bitcoin
export zflist=/tmp/zflist-2.3.0-linux-amd64-musl

echo "[+] stopping bitcoind"

zinit stop bitcoind

echo "[+] waiting for bitcoind cleanup"

while pidof bitcoind > /dev/null; do
    sleep 0.2
done

echo "[+] preparing zflist binary"

if [ ! -f ${zflist} ]; then
    echo "[+] downloading latest version"

    wget -q https://github.com/threefoldtech/0-flist/releases/download/v2.3.0/zflist-2.3.0-linux-amd64-musl -O ${zflist}
    chmod +x ${zflist}
fi

echo "[+] preparing flist environment"

${zflist} close
${zflist} init

echo "[+] creating default directory layout"

${zflist} mkdir /chainstate
${zflist} mkdir /blocks
${zflist} mkdir /indexes

echo "[+] adding chainstate"
${zflist} putdir ${dataroot}/chainstate /chainstate

echo "[+] adding blocks"
${zflist} putdir ${dataroot}/blocks /blocks

echo "[+] adding indexes"
${zflist} putdir ${dataroot}/indexes /indexes

echo "[+] finalizing and exporting"
${zflist} metadata backend --host ${backend_host} --port ${backend_port} --namespace ${backend_name}

today=$(date +%Y-%m-%d)
target="/tmp/bitcoin-snapshot-${today}.flist"
${zflist} commit ${target}

echo "[+] restarting bitcoind"
zinit start bitcoind

echo "[+]"
echo "[+] file ready: ${target}"

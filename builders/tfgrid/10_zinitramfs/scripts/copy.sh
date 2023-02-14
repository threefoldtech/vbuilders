#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/zos/initramfs
rm -f /myhost/zos/initramfs

echo " ** COPY DONE"




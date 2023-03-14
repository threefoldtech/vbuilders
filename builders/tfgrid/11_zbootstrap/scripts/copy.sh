#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/alpine/zbootstrap/
rm -f /myhost/alpine/zbootstrap/*
# cp /code/bin/* /myhost/alpine/zbootstrap/bin/

echo " ** COPY DONE"




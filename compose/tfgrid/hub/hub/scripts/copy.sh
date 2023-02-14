#!/bin/sh
set -e

mkdir -p /app
rm -rf /app/*
cp -R /source/unknown/zhub/app/* /app/
cp /config/* /app/src/
cp /source/ubuntu/zflist/bin/zflist /bin/
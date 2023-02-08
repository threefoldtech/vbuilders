#!/bin/sh

# Copy the zinit binary in our docker context
mkdir -p bin
cp ~/myhost/alpine/zinit/bin/zinit bin/

docker compose up


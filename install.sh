#!/usr/bin/env bash
set -ex
SOURCE=${BASH_SOURCE[0]}
DIR_OF_THIS_SCRIPT="$( dirname "$SOURCE" )"
ABS_DIR_OF_SCRIPT="$( realpath $DIR_OF_THIS_SCRIPT )"
mkdir -p ~/.vmodules/threefoldtech
rm -f ~/.vmodules/threefoldtech/builders
ln -s $ABS_DIR_OF_SCRIPT/builders ~/.vmodules/threefoldtech/builders
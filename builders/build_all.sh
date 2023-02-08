set -ex


pushd generic
bash build_all.sh
popd


pushd tfgrid
bash build_all.sh
popd

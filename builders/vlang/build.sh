set -ex
. args.sh
export DOCKER_BUILDKIT=1
# docker build . -t builder_$NAME
docker build --no-cache . -t builder_$NAME


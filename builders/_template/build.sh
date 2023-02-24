set -ex
source conf.sh

echo " ** BUILD"

if [[ -z "${BPUSH}" ]]; then
    export BPUSH=''
else
    export BPUSH=' --push'
fi

# example export BPLATFORM='--platform=linux/arm64,linux/amd64'
if [[ -z "${BPLATFORM}" ]]; then
    export DOCKER_BUILDKIT=1
    export BPLATFORM=''
    # export TAG='local'
    export TAG='latest'
else
    export DOCKER_BUILDKIT=1
    export BPLATFORM='--platform=linux/arm64,linux/amd64'
    export TAG='latest'
fi

# example export BPLATFORM='--platform=linux/arm64,linux/amd64'
if [[ -z "${NOCACHE}" ]]; then
    export NOCACHE=''
else
    export NOCACHE='--no-cache'
fi


if test -f "$PWD/copyindocker.sh"; then
    bash $PWD/copyindocker.sh
fi

echo " ** BUILD START ****** for ${BNAME}"
docker buildx build . -t despiegk/${BNAME}:${TAG} --ssh default=${SSH_AUTH_SOCK} ${NOCACHE} ${BPLATFORM} ${BPUSH}
# docker image prune -a --force
echo " ** BUILD OK ****** for ${BNAME}"


if [ -d "$PWD/zinit" ] 
then
    #will start a docker and then will shutdown because of the zinit shutdown
    docker rm $NAME -f > /dev/null 2>&1 
    echo " ** BUILD POST INSTALL ****** for ${BNAME}"
    docker run --rm --name $NAME \
            -v $HOME/myhost:/myhost \
            -v $PWD/scripts:/scripts -v $PWD/zinit:/etc/zinit \
            --hostname $NAME \
            despiegk/$BNAME:${TAG}
    echo " ** BUILD POST INSTALL DONE ****** for ${BNAME}"
fi

if test -f "$PWD/copyindocker.sh"; then
    rm -rf myhost
fi



set -ex
source conf.sh

echo " ** BUILD"


if test -f "$PWD/copyindocker.sh"; then
    bash $PWD/copyindocker.sh
fi

echo " ** BUILD START ****** for ${BNAME}"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then 
    docker build . -t despiegk/${BNAME}
else
    if [[ -z "${DOCKERPUSH}" ]]; then
        docker build . -t despiegk/${BNAME}
    else
        docker buildx build . -t despiegk/${BNAME} --platform=linux/arm64,linux/amd64 --push
    fi
fi
echo " ** BUILD OK ****** for ${BNAME}"


if [ -d "$PWD/zinit" ] 
then
    #will start a docker and then will shutdown because of the zinit shutdown
    docker rm $NAME -f > /dev/null 2>&1 
    echo " ** BUILD POST INSTALL ****** for ${BNAME}"
    docker run --rm --name $NAME -v $HOME/myhost:/myhost -v $PWD/scripts:/scripts -v $PWD/zinit:/etc/zinit --hostname $NAME $BNAME
    echo " ** BUILD POST INSTALL DONE ****** for ${BNAME}"
fi

if test -f "$PWD/copyindocker.sh"; then
    rm -rf myhost
fi



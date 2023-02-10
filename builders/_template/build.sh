set -ex
source conf.sh

echo " ** BUILD"


if test -f "$PWD/copyindocker.sh"; then
    bash $PWD/copyindocker.sh
fi

echo " ** BUILD START ****** for ${BNAME}"
docker build . -t despiegk/${BNAME}
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



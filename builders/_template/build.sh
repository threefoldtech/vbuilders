set -ex
source conf.sh

echo " ** BUILD"
set +e
echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME}
echo " ** BUILD OK ****** for ${BNAME}"
set -e


#will start a docker and then will shutdown because of the zinit shutdown
docker rm $NAME -f > /dev/null 2>&1 
echo " ** BUILD POST INSTALL ****** for ${BNAME}"
docker run --name $NAME -v $HOME/myhost:/myhost -v $PWD/scripts:/scripts -v $PWD/zinit:/etc/zinit --hostname $NAME $BNAME
docker rm $NAME -f > /dev/null 2>&1 
echo " ** BUILD POST INSTALL DONE ****** for ${BNAME}"
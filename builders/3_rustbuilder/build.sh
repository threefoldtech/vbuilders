set -ex
source conf.sh
docker rmi ${BNAME} -f

set +e
echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME}
echo " ** BUILD OK ****** for ${BNAME}"
set -ex

docker rm $NAME -f > /dev/null 2>&1 
docker run --name $NAME -it -v $HOME/myhost:/myhost -v $PWD/scripts:/scripts --hostname $NAME $BNAME sh /scripts/copy.sh
docker rm $NAME -f > /dev/null 2>&1 

echo " ** INSTALL DONE, ZINIT NOW COPIED TO ~/myhost"

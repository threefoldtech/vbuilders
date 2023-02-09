set -ex
source conf.sh

echo " ** BUILD"
mkdir -p myhost
rsync -rav $HOME/myhost/alpine/nsc/ myhost/
rsync -rav $HOME/myhost/alpine/natstools/ myhost/
echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME}
rm -rf myhost
echo " ** BUILD OK ****** for ${BNAME}"


# #will start a docker and then will shutdown because of the zinit shutdown
# docker rm $NAME -f > /dev/null 2>&1 
# echo " ** BUILD POST INSTALL ****** for ${BNAME}"
# docker run --name $NAME -v $HOME/myhost:/myhost -v $PWD/scripts:/scripts -v $PWD/zinit:/etc/zinit --hostname $NAME $BNAME
# docker rm $NAME -f > /dev/null 2>&1 
# echo " ** BUILD POST INSTALL DONE ****** for ${BNAME}"


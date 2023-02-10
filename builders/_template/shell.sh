set -ex
source conf.sh

mkdir -p $HOME/myhost

docker rm $NAME -f > /dev/null 2>&1 
docker run --name $NAME -d -v $PWD/scripts:/scripts -v $HOME/myhost:/myhost --hostname $NAME despiegk/$BNAME

docker exec -ti $NAME /bin/sh

docker rm $NAME -f > /dev/null 2>&1 


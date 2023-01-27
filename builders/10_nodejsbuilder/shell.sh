set -ex
source conf.sh

mkdir -p $HOME/myhost

docker rm $NAME -f > /dev/null 2>&1 
docker run -it --name $NAME -d -v $PWD/scripts:/scripts -v $HOME/myhost:/myhost --hostname $NAME --entrypoint /bin/sh $BNAME


docker rm $NAME -f > /dev/null 2>&1 


set -ex
source conf.sh

mkdir -p $HOME/myhost
docker rm $NAME -f > /dev/null 2>&1 

if [[ -z "${ZINIT}" ]]; then
    docker run --name $NAME -it -v $PWD/scripts:/scripts -v $HOME/myhost:/myhost --hostname $NAME despiegk/$BNAME:latest /bin/shell.sh
else
    #we have zinit
    docker run --name $NAME -d -v $PWD/scripts:/scripts -v $HOME/myhost:/myhost --hostname $NAME despiegk/$BNAME:latest
    docker exec -ti $NAME /bin/shell.sh
fi

docker rm $NAME -f > /dev/null 2>&1     




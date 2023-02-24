set -ex
source conf.sh

mkdir -p $HOME/myhost
docker rm $NAME -f > /dev/null 2>&1 

if [[ -z "${ZINIT}" ]]; then
    SHELLCMD='/bin/shell.sh'
    RUNOPTION='-it'
else
    SHELLCMD=''
    RUNOPTION='-d'
fi

docker run --name $NAME $RUNOPTION \
    -v $PWD/scripts:/scripts \
    -v $HOME/myhost:/myhost \
    -v $PWD/zinitrun:/etc/zinit \
    -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
    -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
    --hostname $NAME despiegk/$BNAME:latest $SHELLCMD


    


if [[ -z "${ZINIT}" ]]; then
    echo
else
    docker exec -ti $NAME /bin/shell.sh
fi

docker rm $NAME -f > /dev/null 2>&1     




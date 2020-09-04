ssh-add -L > ~/myhost/authorized_keys
docker rm builder_base -f 2>&1 >> /dev/null
docker run -d --name builder_base -it -v $HOME/myhost:/myhost \
    -p 5000:22 \
    --hostname base \
    builders_base

    # -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \

#UGLY HACK to remove known hosts file 
rm -f ~/.ssh/known_hosts
sleep 0.6

if [ "$1" ]; then
    exit 0
else
    ssh -A -o "StrictHostKeyChecking=no" root@localhost -p 5000
fi


ssh-add -L > ~/myhost/authorized_keys
docker rm builder_python -f
docker run -d --name builder_python -it -v $HOME/myhost:/myhost \
    -p 5001:22 \
    --hostname python \
    builders_python

    # -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \

#UGLY HACK to remove know hosts file 
rm -f ~/.ssh/known_hosts
sleep 0.6

if [ "$1" ]; then
    exit 0
else
    ssh -A -o "StrictHostKeyChecking=no" root@localhost -p 5001
fi

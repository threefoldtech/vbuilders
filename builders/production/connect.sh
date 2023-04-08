ssh-add -L > ~/myhost/authorized_keys
docker rm builder_production -f 2>&1 >> /dev/null
docker run -d --name builder_production -it -v $HOME/myhost:/myhost \
    -p 5005:22 \
    --hostname production \
    builders_production

    # -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \

#UGLY HACK to remove know hosts file 
rm -f ~/.ssh/known_hosts
sleep 0.6


sh base/connect.sh nossh
# sh sonic/connect.sh nossh
sh python/connect.sh nossh

ssh -A -o "StrictHostKeyChecking=no" root@localhost -p 5005

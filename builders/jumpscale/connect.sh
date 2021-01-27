mkdir -p ~/myhost
ssh-add -L > ~/myhost/authorized_keys

docker rm builder_jumpscale -f
docker run -d --name builder_jumpscale -it \
    -v $HOME/myhost:/myhost \
    -v $HOME/myhost/config/jumpscale:/root/.config/jumpscale \
    -p 5002:22 \
    --hostname jumpscale \
    builders_jumpscale

ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:5002"
sleep 2

if [ "$1" ]; then
    exit 0
else
    ssh -A -o "StrictHostKeyChecking=no" root@localhost -p 5002
fi

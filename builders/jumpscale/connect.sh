mkdir -p ~/myhost
ssh-add -L > ~/myhost/authorized_keys
SSH_PORT=5002
SSH_TRAILS=10

docker rm builder_jumpscale -f
docker run -d --name builder_jumpscale -it \
    -v $HOME/myhost:/myhost \
    -v $HOME/myhost/config/jumpscale:/root/.config/jumpscale \
    -p $SSH_PORT:22 \
    --hostname jumpscale \
    builders_jumpscale

ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:$SSH_PORT"

if [ "$1" ]; then
    exit 0
else
    echo "trying connecting over ssh..."
    for i in $(seq 1 $SSH_TRAILS);  do
        ssh -A -o "StrictHostKeyChecking=no" root@localhost -p $SSH_PORT && break || echo "connection failed, trying again..."
        sleep 0.5
    done
fi

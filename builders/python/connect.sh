mkdir -p ~/myhost
ssh-add -L > ~/myhost/authorized_keys

docker rm builder_python -f
docker run -d --name builder_python -it -v $HOME/myhost:/myhost \
    -p 5001:22 \
    --hostname python \
    builders_python

ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:5001"

if [ "$1" ]; then
    exit 0
else
    ssh -A -o "StrictHostKeyChecking=no" root@localhost -p 5001
fi

docker ps -aq | xargs docker stop | xargs docker rm
docker container prune --force
docker image prune -a --force
docker builder prune -f
rm -rf /var/lib/docker/volumes/*
# mkdir -p /var/lib/docker/volumes/
rm -rf ~/myhost
mkdir ~/myhost

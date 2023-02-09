set -x
source conf.sh

mkdir -p myhost
rsync -rav $HOME/myhost/alpine/natstools/ myhost/
rsync -rav $HOME/myhost/alpine/nsc/ myhost/

echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME} 
echo " ** BUILD OK ****** for ${BNAME}"

rm -rf myhost


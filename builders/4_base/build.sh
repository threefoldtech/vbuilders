set -x
source conf.sh

mkdir -p bin
rsync -rav --delete $HOME/myhost/alpine/zinit/ myhost/
set +e
echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME} 
echo " ** BUILD OK ****** for ${BNAME}"
set -e
rm -rf myhost


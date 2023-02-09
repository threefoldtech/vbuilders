set -x
source conf.sh

mkdir -p myhost
rsync -rav --delete $HOME/myhost/alpine/zinit/ myhost/

echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME} 
echo " ** BUILD OK ****** for ${BNAME}"

rm -rf myhost


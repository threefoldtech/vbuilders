set -ex
source conf.sh
docker rmi ${BNAME} -f
echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME}
echo " ** BUILD OK ****** for ${BNAME}"
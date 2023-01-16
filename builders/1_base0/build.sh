set -ex
source conf.sh
docker rmi ${BNAME} -f
set +e
echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME}
set -e

echo " ** BUILD OK ****** for ${BNAME}"
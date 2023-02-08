set -ex
source conf.sh
set +e
echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME}
echo " ** BUILD OK ****** for ${BNAME}"
set -e

set -ex
source versions.sh
for name in "1_tfchain" 
do
    echo "START BUILDING $name"
    pushd $name
    bash build.sh
    popd
done
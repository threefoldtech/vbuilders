set -ex

for name in "1_base0" "2_rustbuilder" "3_base" "5_gobuilder" "5_nodejsbuilder" "6_vbuilder" "7_nsc" "8_natstools" "9_3bot"
do
    echo "START BUILDING $name"
    pushd $name
    bash build.sh
    popd
done

echo "*** BUILD OF ALL DOCKERS WORKED***"


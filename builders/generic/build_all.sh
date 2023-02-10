set -ex

for name in "1_base0" "2_rust0" "3_rustbuilder" "4_base" "5_gobuilder" "5_nodejsbuilder" "6_vbuilder" "7_natstools" "9_3bot"
do
    echo "START BUILDING $name"
    pushd $name
    bash build.sh
    popd
done

echo "*** BUILD OF ALL DOCKERS WORKED***"


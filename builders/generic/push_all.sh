set -ex
docker login

# for name in "base0" "rust0" "rustbuilder" "base" "gobuilder" "nodejsbuilder" "vbuilder" "nsc" "natstools" "3bot"
for name in "base0"
do
    docker push $name
done

echo "*** BUILD OF ALL DOCKERS WORKED***"


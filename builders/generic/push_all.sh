set -ex
docker login

# for name in "base0" "rustbuilder" "base" "gobuilder" "nodejsbuilder" "vbuilder" "nsc" "natstools" "3bot"
for name in "base0"
do
    docker push despiegk/$name:latest
done

echo "*** BUILD OF ALL DOCKERS WORKED***"


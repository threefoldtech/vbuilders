set -ex
mkdir -p /var/syncthing/data
mkdir -p /var/syncthing/config
mkdir -p /var/syncthing/log
cd /var/syncthing/data

syncthing serve --gui-apikey='cqoxASXQwjTaKKt697ozMniZcaiwUefz' --home /var/syncthing --no-upgrade --gui-address='0.0.0.0:8384' 
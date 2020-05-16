

ssh root@172.17.0.2:/

mkdir -p /usr/local/lib/pyenv/versions/3.8.2
mkdir -p /usr/local/bin
rsync -avz --exclude-from '/myhost/exclude-list.txt' root@172.17.0.2:/usr/local/lib/pyenv/versions/3.8.2/ /usr/local/lib/pyenv/versions/3.8.2/
rsync -avz --exclude-from '/myhost/exclude-list.txt' root@172.17.0.2:/usr/local/bin/ /usr/local/bin/
rsync -avz --exclude-from '/myhost/exclude-list.txt' root@172.17.0.2:/usr/lib/ /usr/lib/
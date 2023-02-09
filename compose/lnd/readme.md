# tarantool, nats and compose with our base dockers

## to start

go in directory, do 

```bash
docker compose up
```

To see the logs run 

```bash
#see the logs from lnd daemin (is using our zinit feature)
docker exec -ti lnd sh -c "zinit log"
#see the tmuxp panes (where tests are running)
docker exec -ti tools sh -c "tmux a"
#to see log of generic docker compse (should be empty)
docker-compose logs -f
#go in container of lnd
docker exec -ti lnd sh
```

## lnd

```bash
#create wallet
docker exec -ti lnd sh -c "lncli create"
#unlock (only needed when wallet not unlocked yet, after creation automatically unlocked)
docker exec -ti lnd sh -c "lncli unlock"
```

lndconnect -l -j

/scripts/litd --uipassword=kds007kds --httpslisten=0.0.0.0:8443
open https://127.0.0.1:8443/

```bash
#see if synced done properly
docker exec -ti lnd sh -c "lncli getinfo | grep sync"
```

should output

```
"synced_to_chain": true,
"synced_to_graph": true,
```

## do lightening transactions

https://github.com/LN-Zap/zap-desktop/releases

## to work in any of the docker machines

```bash
docker exec -ti tools /bin/sh
```
in this case container is tools


```bash
#to see containers
docker ps
```

- installed in containers
    - mc (great tool to investigate the container)
    - htop (see resources used)
    - zinit (to manage the startup processes) eg. do zinit list
- you can reach the other containers by using the container name e.g. 'nats' is the machine from nats server
    - e.g. test with ```ping nats```


## usage of tmuxp in tools container

- is a very cool tool to manage tmux see https://tmuxp.git-pull.com/
- see /scripts/nats_test1.yaml to how it works

- go into the tmux session
    - tmux a
- to load   
    - killall tmux //first kill 
    - tmuxp load /scripts/nats_test1.yaml -d
- some shortcuts
    - ctrl b o  //move between windows
    - ctrl b d  //detach

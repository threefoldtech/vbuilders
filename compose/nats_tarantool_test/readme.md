# tarantool, nats and compose with our base dockers

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

## to test if nats works

```bash

#go into the tools container 
docker exec -ti tools /bin/sh

nats context save local --server nats://nats:4222 --description 'local development server' --select 


```

if it all works you see something like

```bash
NATS Configuration Context "local"

      Description: local development server
      Server URLs: nats://nats:4222
             Path: /root/.config/nats/context/local.json
       Connection: OK

```

lets now do some publish & retrieve

```bash
nats publish --durable=10 test.kristof hi
nats subscribe test.kristof

```

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

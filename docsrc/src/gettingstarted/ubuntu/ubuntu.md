# Getting Started Ubuntu

## Deploy a VM on TFGrid

steps

- go to https://play.grid.tf/#/
- chose VM deployer, make sure to have some TFT in your wallet
- I chose 200 GB of storage and 8 Gb of memory

result is something like

![](img/play_ubuntu_done.png)  

Login to your VM with

```bash
#the -A forwards your SSH key (important)
#the ip address is the address as given back by the deploy of the VM on threefold play
ssh -A root@195.192.213.4
```

## Prepare the VM

inside the VM do the following

### if you want to reinstall do

```bash
rm -rf /root/.vmodules
rm -f /root/env.sh
```

### install crystal lib

```bash
#the next line is needed if you want to change a branch
# export CLBRANCH=development2
curl https://raw.githubusercontent.com/threefoldtech/builders/development/scripts/install.sh > /tmp/crystal.sh && bash /tmp/crystal.sh
```



###  docker and docker compose

```bash
#install docker and builder
curl https://raw.githubusercontent.com/threefoldtech/builders/development/scripts/installers/docker.sh > /tmp/docker.sh && bash /tmp/docker.sh
```

### to make sure you are using the right branch of crystal and builder tools

```bash
cd ~/.vmodules/threefoldtech/builder && git checkout development
cd ~/.vmodules/freeflowuniverse/crystallib && git checkout development2
```

theck the output you should see that you are on the right branch

## Build the base dockers


```

```






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
#the -A forwards your SSH key
#the ip address is the address as given back by the deploy of the VM on threefold play
ssh -A root@195.192.213.4
```

## Prepare the VM

inside the VM do the following

### install crystal lib

```bash
#install docker and builder
curl https://raw.githubusercontent.com/threefoldtech/builders/development/scripts/install.sh > /tmp/crystal.sh && bash /tmp/crystal.sh
```


###  docker and docker compose

```bash
#install docker and builder
curl https://raw.githubusercontent.com/threefoldtech/builders/development/scripts/installers/docker.sh > /tmp/docker.sh && bash /tmp/docker.sh
```

## Build the base dockers


```
cd ~/code/github/threefoldtech/builders/builders/generic/
bash build_all.sh
```

## Re-Build the base dockers


```
cd ~/code/github/threefoldtech/builders/builders/generic/
bash delete_all.sh
bash build_all.sh
```





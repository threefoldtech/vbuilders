# Builders

Documentation on https://threefoldtech.github.io/builders/ (work in progress)

## prerequisites


### for ubuntu 

- docker and docker compose

```bash
curl https://raw.githubusercontent.com/threefoldtech/builders/master/scripts/installers/docker.sh > /tmp/install.sh && bash /tmp/install.sh
```

execute the [docker install script](scripts/installers/docker.sh) if on Ubuntu

## the base docker builders builder

- see dir builder

### to push the images and build multiplatform

- now only on m.1 osx
- do 'export DOCKERPUSH=1'

to check result of building `docker manifest inspect despiegk/base0:latest`

## vlang install

```bash
curl https://raw.githubusercontent.com/threefoldtech/builders/master/scripts/install.sh > /tmp/install.sh && bash /tmp/install.sh

#if you want to debug do
curl https://raw.githubusercontent.com/threefoldtech/builders/master/scripts/install.sh > /tmp/install.sh && bash -x /tmp/install.sh
```

## install on remote server over ssh

You need ssh-key loaded in ssh-agent

```bash
#add your ip addr here
export ME='195.192.213.92'

<<<<<<< HEAD
#do the install
ssh -A root@$ME "curl https://raw.githubusercontent.com/threefoldtech/builders/master/scripts/install.sh > /tmp/install.sh && bash -x /tmp/install.sh"

#to login to your machine
ssh -A root@$ME

#to reset all (same as install but will restart)
ssh -A root@$ME "export RESET=1 && curl https://raw.githubusercontent.com/threefoldtech/builders/master/scripts/install.sh > /tmp/install.sh && bash -x /tmp/install.sh"

```
=======
- base: ssh:5000
- python: 5001
- production: ssh:5005
- tarantool: ssh:5006
- golang: ssh:5007
- yggdrasil: ssh:5008

>>>>>>> kristof

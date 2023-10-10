module sftpgo

import freeflowuniverse.crystallib.docker

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build sftpgo: reset:${args.reset}')

	mut r := engine.recipe_new(name: '3bot', platform: .alpine)

	r.add_from(image: 'golang', tag: '1.20-bullseye')!

	r.add_run(cmd: 'apk add git')!
	r.add_run(
		cmd: '
		git clone https://github.com/freeflowuniverse/aydo.git /aydo
		cd /aydo 
    go build -o sftpgo
	'
	)!

	r.add_from(image: 'onlyoffice/documentserver', tag: '7.3')!
	r.add_run(
		cmd: '
		cp zinit /etc/zinit
		cp sftpgo /var/lib/sftpgo
		cp ds.conf.tmpl /etc/onlyoffice/documentserver/nginx/ds.conf.tmpl
		cp /aydo/sftpgo /usr/bin/
		cp /aydo/templates /usr/share/sftpgo/templates
		cp /aydo/static /usr/share/sftpgo/static
		cp /aydo/openapi /usr/share/sftpgo/openapi
	'
	)!

	r.add_run(
		cmd: '
		apt update
		apt install -y openssh-server dnsutils
	'
	)!

	r.add_run(
		cmd: '
		wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.11/zinit 
		chmod +x /sbin/zinit
	'
	)!

	r.add_entrypoint(cmd: 'zinit init')!

	r.build(args.reset)!
}

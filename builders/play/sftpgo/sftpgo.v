module sftpgo

import freeflowuniverse.crystallib.osal.docker

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build sftpgo: reset:${args.reset}')

	mut r := engine.recipe_new(name: 'sftpgo', platform: .alpine)

	r.add_from(image: 'golang', tag: '1.20-bullseye', alias: "aydo-builder")!

	r.add_run(
		cmd: '
		git clone https://github.com/freeflowuniverse/aydo.git /aydo
		cd /aydo 
    go build -o sftpgo
	'
	)!

	configurl := 'https://raw.githubusercontent.com/threefoldtech/tf-images/development/tfgrid3/aydo'
	r.add_run(cmd: 'wget ${configurl}/ds.conf.tmpl -O /root/ds.conf.tmpl')!
	r.add_run(cmd: '
	mkdir /root/sftpgo
	mkdir /root/zinit
	')!
	r.add_run(cmd: 'wget ${configurl}/sftpgo/sftpgo.json -O /root/sftpgo/sftpgo.json')!
	r.add_run(cmd: 'wget ${configurl}/zinit/onlyoffice.yaml -O /root/zinit/onlyoffice.yaml')!
	r.add_run(cmd: 'wget ${configurl}/zinit/sftpgo.yaml -O /root/zinit/sftpgo.yaml')!
	r.add_run(cmd: 'wget ${configurl}/zinit/sshd.yaml -O /root/zinit/sshd.yaml')!
	r.add_run(cmd: 'wget ${configurl}/zinit/sshkey.yaml -O /root/zinit/sshkey.yaml')!

	r.add_from(image: 'onlyoffice/documentserver', tag: '7.3')!

	r.add_copy(from: "aydo-builder", source: "/root/zinit", dest: "/etc/zinit")!
	r.add_copy(from: "aydo-builder", source: "/root/sftpgo/sftpgo.json", dest: "/var/lib/sftpgo/sftpgo.json")!
	r.add_copy(from: "aydo-builder", source: "/root/ds.conf.tmpl", dest: "/etc/onlyoffice/documentserver/nginx/ds.conf.tmpl")!

	r.add_copy(from: "aydo-builder", source: "/aydo/sftpgo", dest: "/usr/bin/")!
	r.add_copy(from: "aydo-builder", source: "/aydo/templates", dest: "/usr/share/sftpgo/templates")!
	r.add_copy(from: "aydo-builder", source: "/aydo/static", dest: "/usr/share/sftpgo/static")!
	r.add_copy(from: "aydo-builder", source: "/aydo/openapi", dest: "/usr/share/sftpgo/openapi")!

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

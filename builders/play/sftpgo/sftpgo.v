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

	configurl := 'https://raw.githubusercontent.com/threefoldtech/builders/development/builders/play/sftpgo/'

	r.add_run(cmd: 'wget ${configurl}/ds.conf.tmpl -O /root/ds.conf.tmpl')!
	r.add_run(cmd: '
	mkdir /root/sftpgo
	mkdir /root/zinit
	')!
	r.add_run(cmd: 'wget ${configurl}/sftpgo/sftpgo.json -O /root/sftpgo/sftpgo.json')!

	r.add_from(image: 'onlyoffice/documentserver', tag: '7.3')!

	r.add_copy(from: "aydo-builder", source: "/root/sftpgo/sftpgo.json", dest: "/var/lib/sftpgo/sftpgo.json")!
	r.add_copy(from: "aydo-builder", source: "/root/ds.conf.tmpl", dest: "/etc/onlyoffice/documentserver/nginx/ds.conf.tmpl")!

	r.add_copy(from: "aydo-builder", source: "/aydo/sftpgo", dest: "/usr/bin/")!
	r.add_copy(from: "aydo-builder", source: "/aydo/templates", dest: "/usr/share/sftpgo/templates")!
	r.add_copy(from: "aydo-builder", source: "/aydo/static", dest: "/usr/share/sftpgo/static")!
	r.add_copy(from: "aydo-builder", source: "/aydo/openapi", dest: "/usr/share/sftpgo/openapi")!

	r.add_sshserver()!
	r.add_zinit_cmd(
		name: 'onlyoffice'
		exec: '
			export PRODUCT_NAME=documentserver
			export PG_VERSION=14
			export DS_DOCKER_INSTALLATION=true
			export PRODUCT_EDITION= 
			export COMPANY_NAME=onlyoffice
			export JWT_ENABLED=false
			export REDIS_SERVER_HOST=localhost
			/bin/bash -c /app/ds/run-document-server.sh
		'
	)!
	r.add_zinit_cmd(
		name: 'sftpgo',
		exec: "
			export PUB_IP=$(dig +short txt ch whoami.cloudflare @1.0.0.1 | awk -F'\"' '{ print $2}')
			export SFTP_SERVER_ADDR=http://\$PUB_IP:80
			export ONLYOFFICE_SERVER_ADDR=http://\$PUB_IP:4000
			export SFTPGO_DEFAULT_ADMIN_USERNAME=admin
  		export SFTPGO_DEFAULT_ADMIN_PASSWORD=admin
			exec /usr/bin/sftpgo serve -c /var/lib/sftpgo
		"
	)!
	
	r.add_zinit()!

	r.build(args.reset)!
}

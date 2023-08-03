module threebot

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	gobuilder.build(engine: engine, reset: args.reset, strict: args.strict)!

	mut r := engine.recipe_new(name: '3bot', platform: .alpine)

	r.add_from(image: 'gobuilder')!

	r.add_run(cmd: 'apk add git')!
	r.add_run(cmd: 'git clone https://github.com/threefoldtech/3bot')!
	r.add_workdir(workdir: './3bot')!
	r.add_run(
		cmd: '
		cd web3gw/server 
    	CGO_ENABLED=1
		GOOS=linux 
		go build -o 3bot 
    	chmod +x 3bot
		cp 3bot /usr/bin/3bot
		'
	)!
	r.add_run(
		cmd: '
        mkdir -p /var/lib/sftpgo /sftpgo
        cp sftpgo.json /var/lib/sftpgo/
		'
	)!

	r.add_workdir(workdir: '/var/lib/sftpgo')!
	r.add_run(cmd: 'git clone https://github.com/freeflowuniverse/aydo /sftpgo')!

	r.add_expose(ports: ['8080', '8060'])!

	r.add_entrypoint(cmd: '/usr/bin/3bot -sftp-config-dir .')!

	r.build(args.reset)!
}

fn main() {
	build() or { panic(err) }
}

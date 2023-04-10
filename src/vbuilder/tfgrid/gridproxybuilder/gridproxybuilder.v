module gridproxybuilder

import freeflowuniverse.crystallib.docker
import threefoldtech.vbuilder.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	gobuilder.build(engine: engine, reset: args.reset, strict: args.strict)!

	mut r := engine.recipe_new(name: 'gridproxy', platform: .alpine, zinit: true)

	r.add_from(image: 'gobuilder')!

	// QUESTION: I don;t think next is needed, prob done automatically
	// r.add_zinit()!
	r.add_run(cmd: 'apk add git')!
	r.add_run(cmd: 'git clone https://github.com/threefoldtech/tfgridclient_proxy')!
	r.add_workdir(workdir: './tfgridclient_proxy')!
	r.add_run(
		cmd: '
		cd cmds/proxy_server 
    	CGO_ENABLED=0 
		GOOS=linux 
		go build -ldflags "-w -s -X main.GitCommit=$(git describe --tags --abbrev=0) -extldflags \'-static\'"  -o gridrest 
    	chmod +x gridrest
		cp gridrest /usr/bin/gridrest"
		'
	)!
	r.add_run(cmd: 'cp -r rootfs/* /')!
	r.add_env('SERVER_PORT', ':443')!
	r.add_env('POSTGRES_HOST', 'postgres')!
	r.add_env('POSTGRES_PORT', '5432')!
	r.add_env('POSTGRES_DB', 'name')!
	r.add_env('POSTGRES_USER', 'postgres')!
	r.add_env('POSTGRES_PASSWORD', '123')!
	r.build(args.reset)!
}

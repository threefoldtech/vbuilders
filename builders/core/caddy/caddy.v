module caddy

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	gobuilder.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'caddy', platform: .alpine)

	r.files << $embed_file('templates/Caddyfile')


	r.add_from(image: 'gobuilder', alias: 'builder')!

	r.add_run(
		cmd: '
		go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

	'
	)!

	r.add_run(
		cmd: '
		export CGO_ENABLED=1
		export GOOS=linux
		export PATH=\$PATH:/app/bin
		cd /tmp
		xcaddy build  --with github.com/caddyserver/ntlm-transport 
	'
	)!

	//
	// --with github.com/caddyserver/forwardproxy

	r.add_from(image: 'base', alias: 'installer')!
    // we are now in phase 2, and start from a clean image, we call this layer 'installer'
    //we now add the file as has been build in step one to phase 2
	r.add_copy(from:"builder", source:"/tmp/caddy", dest:"/bin/caddy")!

	r.add_expose(ports:['80'])!
	r.add_expose(ports:['443'])!

	r.add_file_embedded(source: 'Caddyfile', dest: '/etc/caddy/Caddyfile')!

	r.add_zinit_cmd(name:"caddy", exec:"/bin/caddy")!	

	r.build(args.reset)!
}

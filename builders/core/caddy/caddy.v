module caddy

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	gobuilder.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'caddy', platform: .alpine)

	r.add_from(image: 'gobuilder', alias: 'builder')!

	r.add_run(
		cmd: '
		go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

	'
	)!

	r.add_run(
		cmd: '
		#install nats
		CGO_ENABLED=1
		GOOS=linux
		xcaddy build --with github.com/caddyserver/nginx-adapter
			--with github.com/caddyserver/ntlm-transport
			--with github.com/caddyserver/forwardproxy
	'
	)!

	r.build(args.reset)!
}

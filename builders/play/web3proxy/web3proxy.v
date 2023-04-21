
module web3proxy

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	gobuilder.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'web3proxy', platform: .alpine)

	r.add_from(image: 'gobuilder', alias: 'builder')!

	r.add_codeget(url: 'https://github.com/threefoldtech/web3_proxy/tree/development_check/server', dest: '/code/web3_proxy')!

	r.add_run(
		cmd: '
		cd /code/web3_proxy
		go build .
		cp server /bin/web3proxy
		'
	)!

	r.add_from(image: 'base', alias: 'installer')!

	r.add_copy(from: 'builder', source: '/bin/web3proxy', dest: '/bin/web3proxy')!

	r.add_expose(ports: ['8080'])!

	// TODO should add test curl command to it
	r.add_zinit_cmd(
		name: 'goca'
		exec: '
				echo we did it, web3proxy is there
				/bin/web3proxy
			'
	)!
	r.build(args.reset)!
}

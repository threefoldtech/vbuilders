module zola

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.rustbuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build zola: reset:${args.reset}')

	// make sure dependency has been build
	rustbuilder.build(engine: engine)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'zola', platform: .alpine)

	r.add_from(image: 'rustbuilder', alias: 'builder')!

	r.add_rustbuild_from_code(
		url: 'https://github.com/getzola/zola'
		name: 'zola'
		buildcmd: 'cargo install --path . --locked'
		copycmd: 'cp target/release/zola /bin/zola'
	)!

	r.add_from(image: 'base', alias: 'installer')!
	r.add_copy(from: 'builder', source: '/bin/zola', dest: '/bin/zola')!

	// r.add_expose(ports:['9651'])!

	// r.add_zinit_cmd(name:"caddy", exec:"/bin/caddy")!	

	r.build(args.reset)!
}

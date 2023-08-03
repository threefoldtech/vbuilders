module mycelium

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.rustbuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build mycelium: reset:${args.reset}')

	// make sure dependency has been build
	rustbuilder.build(engine: engine)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'mycelium', platform: .alpine)

	r.add_from(image: 'rustbuilder', alias: 'builder')!

	r.add_codeget(url: 'git@github.com:threefoldtech/mycelium.git', dest: '/code/mycelium')!	

	r.add_run(
		cmd: '
		cd /code/mycelium
		cargo build
		cp /code/mycelium/target/debug/mycelium /bin/mycelium
	'
	)!


	r.add_from(image: 'base', alias: 'installer')!
    // we are now in phase 2, and start from a clean image, we call this layer 'installer'
    //we now add the file as has been build in step one to phase 2
	r.add_copy(from:"builder", source:'/bin/mycelium', dest:"/bin/mycelium")!

	r.add_expose(ports:['9651'])!

	// r.add_zinit_cmd(name:"caddy", exec:"/bin/caddy")!	

	r.build(args.reset)!
}

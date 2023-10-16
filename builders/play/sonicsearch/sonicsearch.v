module sonicsearch

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.rustbuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build sonicsearch: reset:${args.reset}')

	// make sure dependency has been build
	rustbuilder.build(engine: engine)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'sonicsearch', platform: .alpine)

	r.add_from(image: 'rustbuilder', alias: 'builder')!

	r.add_package(name: 'llvm16-dev, libc6-compat, g++, cmake, make, libc-dev, clang16-libclang')!

	r.add_rustbuild_from_code(
		url: 'https://github.com/valeriansaliou/sonic'
		name: 'sonicsearch'
		debug: true
	)!

	// r.add_from(image: 'base', alias: 'installer')!
	// we are now in phase 2, and start from a clean image, we call this layer 'installer'
	// we now add the file as has been build in step one to phase 2
	// r.add_copy(from:"builder", source:'/bin/sonicsearch', dest:"/bin/sonicsearch")!

	// r.add_expose(ports:['9651'])!

	// r.add_zinit_cmd(name:"caddy", exec:"/bin/caddy")!	

	r.build(args.reset)!
}

module cbuilder

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.base0

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build cbuilder: reset:${args.reset}')

	// make sure dependency has been build
	base0.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'cbuilder', platform: .alpine)

	r.add_from(image: 'base0')!

	r.add_package(name: 'git, musl-dev, clang, gcc, make')!

	r.add_zinit()!

	r.build(args.reset)!
}

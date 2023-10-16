module gobuilder

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.base

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build gobuilder: reset:${args.reset}')

	// make sure dependency has been build
	base.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'gobuilder', platform: .alpine)

	r.add_from(image: 'base')!
	r.add_gobuilder()!
	r.add_zinit()!
	r.build(args.reset)!
}

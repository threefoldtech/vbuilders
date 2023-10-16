module rustbuilder

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.rust0

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build rustbuilder: reset:${args.reset}')

	// make sure dependency has been build
	rust0.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'rustbuilder', platform: .alpine)

	r.add_from(image: 'rust0')!

	r.add_zinit()!

	r.build(args.reset)!
}

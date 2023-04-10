module rust0

import freeflowuniverse.crystallib.docker
import threefoldtech.vbuilder.core.base0

const rustversion = '1.67.0'

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(" - build rust0: reset:$args.reset")

	base0.build(engine: engine, reset: args.reset, strict: args.strict)!


	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'rust0', platform: .alpine, zinit: false)

	r.files << $embed_file('templates/rust_install.sh')

	r.add_from(image: 'base0')!

	r.add_package(name: 'musl-dev, gcc')!

	r.add_env(env: 'RUST_VERSION=${rust0.rustversion}')!

	r.execute(source: 'rust_install.sh')!

	r.build(args.reset)!
}

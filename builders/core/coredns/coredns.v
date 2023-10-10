module coredns

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	gobuilder.build(engine: engine)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'coredns', platform: .alpine)

	r.files << $embed_file('templates/coredns_start.sh')

	r.add_from(image: 'gobuilder', alias: 'builder')!

	r.add_package(name: 'make')!

	r.add_gobuild_from_code(
		url: 'https://github.com/coredns/coredns'
		name: 'coredns'
		buildcmd: 'make'
		copycmd: 'cp coredns /bin/coredns'
	)!

	r.add_from(image: 'base', alias: 'installer')!
	r.add_copy(from: 'builder', source: '/bin/coredns', dest: '/bin/coredns')!

	// r.add_expose(ports:['8384'])!

	// r.add_file_embedded(source: 'coredns_start.sh', dest: '/bin/coredns_start.sh')!

	// r.add_zinit_cmd(name:"coredns", exec:"/bin/coredns_start.sh")!	

	r.build(args.reset)!
}

module mdbook

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.rustbuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build mdbook: reset:${args.reset}')

	// make sure dependency has been build
	rustbuilder.build(engine: engine)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'mdbook', platform: .alpine)

	r.add_from(image: 'rustbuilder', alias: 'builder')!

	r.add_rust_package(name: 'mdbook, mdbook-echarts, mdbook-mermaid')!

	r.add_download(
		url: 'https://cdnjs.cloudflare.com/ajax/libs/echarts/5.4.3/@name'
		name: 'echarts.min.js'
		reset: false
		dest: '/assets/@name'
		minsize_kb: 1000
		maxsize_kb: 2000
	)!

	r.add_run(
		cmd: '
		source ~/.cargo/env
		cargo install mdbook-plantuml --no-default-features --features plantuml-server
		'
	)!

	r.add_from(image: 'base', alias: 'installer')!
	// we are now in phase 2, and start from a clean image, we call this layer 'installer'
	// we now add the file as has been build in step one to phase 2
	r.add_copy(from: 'builder', source: '/root/.cargo/bin/mdbook', dest: '/bin/mdbook')!
	r.add_copy(
		from: 'builder'
		source: '/root/.cargo/bin/mdbook-echarts'
		dest: '/bin/mdbook-echarts'
	)!
	r.add_copy(
		from: 'builder'
		source: '/root/.cargo/bin/mdbook-mermaid'
		dest: '/bin/mdbook-mermaid'
	)!
	r.add_copy(
		from: 'builder'
		source: '/root/.cargo/bin/mdbook-plantuml'
		dest: '/bin/mdbook-plantuml'
	)!
	r.add_copy(from: 'builder', source: '/assets/echarts.min.js', dest: '/assets/echarts.min.js')!

	// r.add_expose(ports:['9651'])!

	// r.add_zinit_cmd(name:"caddy", exec:"/bin/caddy")!	

	r.build(args.reset)!
}

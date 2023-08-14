module main

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.zdb

fn do() ! {
	prefix:=""
	reset:=false
	localonly:=false

	mut engine := docker.new(prefix:prefix, localonly:localonly)!

	if reset{
		engine.reset_all()!
	}

	zdb.build(engine:&engine, reset:true)!

	engine.
}

fn main() {

	do() or { panic(err) }
}

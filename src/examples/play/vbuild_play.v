
module main


import freeflowuniverse.crystallib.docker

import threefoldtech.vbuilder.core.gobuilder
import threefoldtech.vbuilder.core.vbuilder
import threefoldtech.vbuilder.core.rustbuilder
import threefoldtech.vbuilder.core.nodejsbuilder
import threefoldtech.vbuilder.core.natstools
import threefoldtech.vbuilder.core.caddy
import threefoldtech.vbuilder.play.goca
import threefoldtech.vbuilder.tfgrid.dashboard
// import threefoldtech.vbuilder.tfgrid.playground
import threefoldtech.vbuilder.tfgrid.tfchainbuilder
import threefoldtech.vbuilder.tfgrid.gridproxybuilder




fn do() ! {

	dockerregistry_datapath:=""
	// dockerregistry_datapath:="/Volumes/FAST/DOCKERHUB"
	prefix:="despiegk/" //dont forget trailing slash
	reset:=false
	localonly:=false

	mut engine := docker.new(prefix:prefix,localonly:localonly)!

	if dockerregistry_datapath.len>0{
		engine.registry_add(datapath:dockerregistry_datapath)! //this means we run one locally
	}
	
	if reset{
		//TODO: prob better to only remove what is relevant to building
		engine.reset_all()!
	}

	
	// gobuilder.build(engine:&engine,reset:args.reset)!
	// nodejsbuilder.build(engine:&engine,reset:args.reset)!
	// vbuilder.build(engine:&engine,reset:args.reset)!
	// rustbuilder.build(engine:&engine,reset:args.reset)!
	// natstools.build(engine:&engine,reset:args.reset)!	
	// caddy.build(engine:&engine,reset:args.reset)!	
	goca.build(engine:&engine,reset:reset)!

}

fn main() {

	do() or { panic(err) }
}

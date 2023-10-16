
module main

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.gobuilder
import threefoldtech.builders.core.vbuilder
import threefoldtech.builders.core.rustbuilder
import threefoldtech.builders.core.nodejsbuilder
import threefoldtech.builders.core.natstools
import threefoldtech.builders.core.caddy
import threefoldtech.builders.play.goca
import threefoldtech.builders.play.sftpgo
import threefoldtech.builders.play.threebot
import threefoldtech.builders.tfgrid.dashboard
// import threefoldtech.builders.tfgrid.playground
import threefoldtech.builders.tfgrid.tfchainbuilder
import threefoldtech.builders.tfgrid.gridproxybuilder

fn do() ! {

	dockerregistry_datapath:=""
	// dockerregistry_datapath:="/Volumes/FAST/DOCKERHUB"
	// prefix:="despiegk/" //dont forget trailing slash
	prefix:=""
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
	// goca.build(engine:&engine,reset:reset)!
	// sftpgo.build(engine:&engine,reset:true)!
	threebot.build(engine:&engine,reset:true)!

}

fn main() {

	do() or { panic(err) }
}

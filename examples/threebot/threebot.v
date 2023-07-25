
module main


import freeflowuniverse.crystallib.docker

import threefoldtech.builders.play.threebot



fn do() ! {

	dockerregistry_datapath:=""
	prefix:=""
	reset:=false
	localonly:=false

	mut engine := docker.new(prefix:prefix,localonly:localonly)!
	
	threebot.build(engine:&engine,reset:true)!

}

fn main() {

	do() or { panic(err) }
}
